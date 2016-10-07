//
//  MasterViewController.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import CoreData
import UIKit

class MasterViewController: UIViewController, UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    var selectedTabTitle = ""

    // Set default values
    var contentType: ContentType = .tv
    var contentCategory: ContentCategory = .popular

    @IBOutlet weak var tabBar: UITabBar!

    @IBOutlet weak var tvTab: UITabBarItem!
    @IBOutlet weak var movieTab: UITabBarItem!
    @IBOutlet weak var personTab: UITabBarItem!

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserDefaults()
        setupFetchedResultsController()
        try! fetchedResultsController.performFetch()

        let space = CGFloat(3.0)
        let width = Double(self.view.frame.size.width)
        let dimension = CGFloat((width - (2 * Double(space))) / 3.0)

        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        tabBar.delegate = self
        collectionView.delegate = self
        fetchedResultsController.delegate = self
    }

    func setupUserDefaults() {
        let contentType = UserDefaults.standard.string(forKey: "contentType")
        let contentCategory = UserDefaults.standard.string(forKey: "contentCategory")
        let selectedSegment = UserDefaults.standard.integer(forKey: "selectedSegment")

        if contentType != nil {
            self.contentType = ContentType(rawValue: contentType!)!

            // Set tag
            let tag: Int
            switch self.contentType {
            case .tv: tag = 0
            case .movie: tag = 1
            case .person: tag = 2
            }

            // Find tab bar with tag
            self.tabBar.items!.forEach {
                if tag == $0.tag {
                    self.tabBar.selectedItem = $0
                    self.tabBar(self.tabBar, didSelect: $0)
                }
            }
        }

        if contentCategory != nil {
            self.contentCategory = ContentCategory(rawValue: contentCategory!)!
            self.segmentedControl.selectedSegmentIndex = selectedSegment
        }
    }

    func setupFetchedResultsController() {
        let entityName = contentType.rawValue.capitalized
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "category = %@", contentCategory.rawValue)
        fetchRequest.sortDescriptors = []

        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    @IBAction func reloadData(_ sender: AnyObject) {

        refreshButton.isEnabled = false

        API.getContent(contentType: contentType, contentCategory: contentCategory, handler: {

            let results = $0["results"] as! [[String: Any]]
            let contentType = $0["contentType"] as! ContentType
            let contentCategory = $0["contentCategory"] as! ContentCategory
            let context = CoreDataStackManager.sharedInstance().managedObjectContext

            DispatchQueue.main.async {
                switch contentType {
                case .tv:
                    (self.fetchedResultsController.fetchedObjects as! [Tv]).forEach { context.delete($0) }
                    results.forEach { result in
                        Tv(data: result, category: contentCategory.rawValue, insertInto: context)
                    }
                case .movie:
                    (self.fetchedResultsController.fetchedObjects as! [Movie]).forEach { context.delete($0) }
                    results.forEach { result in
                        Movie(data: result, category: contentCategory.rawValue, insertInto: context)
                    }
                case .person:
                    (self.fetchedResultsController.fetchedObjects as! [Person]).forEach { context.delete($0) }
                    results.forEach { result in
                        Person(data: result, category: contentCategory.rawValue, insertInto: context)
                    }
                }

                CoreDataStackManager.sharedInstance().saveContext()
                try! self.fetchedResultsController.performFetch()

                self.collectionView.reloadData()
                self.refreshButton.isEnabled = true
            }
        })
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.title != selectedTabTitle {

            selectedTabTitle = item.title!
            segmentedControl.removeAllSegments()

            switch item.tag {
            case 0:
                contentType = .tv
                for (index, title) in ["Popular", "Top Rated", "On The Air", "Airing Today"].enumerated() {
                    segmentedControl.insertSegment(withTitle: title, at: index, animated: true)
                }
            case 1:
                contentType = .movie
                for (index, title) in ["Popular", "Upcoming", "Top Rated", "Now Playing"].enumerated() {
                    segmentedControl.insertSegment(withTitle: title, at: index, animated: true)
                }
            case 2:
                contentType = .person
                segmentedControl.insertSegment(withTitle: "Popular", at: 0, animated: true)
            default:
                break
            }

            UserDefaults.standard.set(contentType.rawValue, forKey: "contentType")
            segmentedControl.selectedSegmentIndex = 0
            selectCategory(segmentedControl)
        }

    }
    
    @IBAction func selectCategory(_ sender: UISegmentedControl) {

        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        let category = title.lowercased().replacingOccurrences(of: " ", with: "_")

        contentCategory = ContentCategory(rawValue: category)!
        UserDefaults.standard.set(category, forKey: "contentCategory")
        UserDefaults.standard.set(segmentedControl.selectedSegmentIndex, forKey: "selectedSegment")

        setupFetchedResultsController()
        try! fetchedResultsController.performFetch()

        collectionView.reloadData()
    }

    // MARK: Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchedResultsController.fetchedObjects!.count == 0 {
            reloadData(collectionView)
        }
        return fetchedResultsController.fetchedObjects!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell

        cell.activityIndicator.startAnimating()

        switch contentType {
        case .tv:
            let content = fetchedResultsController.object(at: indexPath) as! Tv
            if content.imageData != nil {
                cell.activityIndicator.stopAnimating()

                cell.imageView.image = UIImage(data: content.imageData! as Data)
            } else {
                API.getImage(ext: content.imageUrl!, handler: { data in
                    DispatchQueue.main.async {
                        cell.activityIndicator.stopAnimating()

                        content.imageData = data as NSData?
                        CoreDataStackManager.sharedInstance().saveContext()
                        cell.imageView.image = UIImage(data: content.imageData! as Data)
                    }
                })
            }
        case .movie:
            let content = fetchedResultsController.object(at: indexPath) as! Movie
            if content.imageData != nil {
                cell.activityIndicator.stopAnimating()

                cell.imageView.image = UIImage(data: content.imageData! as Data)
            } else {
                API.getImage(ext: content.imageUrl!, handler: { data in
                    DispatchQueue.main.async {
                        cell.activityIndicator.stopAnimating()

                        content.imageData = data as NSData?
                        CoreDataStackManager.sharedInstance().saveContext()
                        cell.imageView.image = UIImage(data: content.imageData! as Data)
                    }
                })
            }
        case .person:
            let content = fetchedResultsController.object(at: indexPath) as! Person
            if content.imageData != nil {
                cell.activityIndicator.stopAnimating()

                cell.imageView.image = UIImage(data: content.imageData! as Data)
            } else {
                API.getImage(ext: content.imageUrl!, handler: { data in
                    DispatchQueue.main.async {
                        cell.activityIndicator.stopAnimating()

                        content.imageData = data as NSData?
                        CoreDataStackManager.sharedInstance().saveContext()
                        cell.imageView.image = UIImage(data: content.imageData! as Data)
                    }
                })
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let content = fetchedResultsController.object(at: indexPath)
        let contentType = self.contentType

        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.content = content
        detailViewController.contentType = contentType
        detailViewController.modalTransitionStyle = .crossDissolve
        present(detailViewController, animated: true, completion: nil)
    }

}
