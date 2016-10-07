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

    // Set default values
    var contentType: ContentType = .tv
    var contentCategory: ContentCategory = .popular

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var tvTab: UITabBarItem!
    @IBOutlet weak var movieTab: UITabBarItem!
    @IBOutlet weak var personTab: UITabBarItem!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFetchedResultsController()
        try! fetchedResultsController.performFetch()
        print(fetchedResultsController.fetchedObjects!.count)

        tabBar.delegate = self
        collectionView.delegate = self
        fetchedResultsController.delegate = self
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
            }
        })
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        segmentedControl.removeAllSegments()

        switch item.tag {
        case 0:
            contentType = .tv
            segmentedControl.insertSegment(withTitle: "Popular", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "Top Rated", at: 1, animated: true)
            segmentedControl.insertSegment(withTitle: "On The Air", at: 2, animated: true)
            segmentedControl.insertSegment(withTitle: "Airing Today", at: 3, animated: true)
        case 1:
            contentType = .movie
            segmentedControl.insertSegment(withTitle: "Popular", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "Upcoming", at: 1, animated: true)
            segmentedControl.insertSegment(withTitle: "Top Rated", at: 2, animated: true)
            segmentedControl.insertSegment(withTitle: "Now Playing", at: 3, animated: true)
        case 2:
            contentType = .person
            segmentedControl.insertSegment(withTitle: "Popular", at: 0, animated: true)
        default:
            break
        }

        segmentedControl.selectedSegmentIndex = 0
        selectCategory(segmentedControl)
    }
    
    @IBAction func selectCategory(_ sender: UISegmentedControl) {

        let title = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        let category = title.lowercased().replacingOccurrences(of: " ", with: "_")

        contentCategory = ContentCategory(rawValue: category)!

        setupFetchedResultsController()
        try! fetchedResultsController.performFetch()
        print(fetchedResultsController.fetchedObjects!.count)

        collectionView.reloadData()
    }

    // MARK: Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    }

}
