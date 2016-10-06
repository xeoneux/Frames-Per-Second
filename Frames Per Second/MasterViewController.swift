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

    var contentType: ContentType? = [ContentType.tv, ContentType.movie, ContentType.person][Int(arc4random_uniform(3))]
    var contentCategory: ContentCategory?

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var tvTab: UITabBarItem!
    @IBOutlet weak var movieTab: UITabBarItem!
    @IBOutlet weak var personTab: UITabBarItem!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let entityName = contentType!.rawValue.capitalized
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = []

        let context = CoreDataStackManager.sharedInstance().managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        tabBar.delegate = self
        collectionView.delegate = self
        fetchedResultsController.delegate = self
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

        if let contentType = contentType {
            switch contentType {
            case .tv:
                switch sender.selectedSegmentIndex {
                case 0: contentCategory = .popular
                case 1: contentCategory = .top_rated
                case 2: contentCategory = .on_the_air
                case 3: contentCategory = .airing_today
                default:
                    break
                }
            case .movie:
                switch sender.selectedSegmentIndex {
                case 0: contentCategory = .popular
                case 1: contentCategory = .upcoming
                case 2: contentCategory = .top_rated
                case 3: contentCategory = .now_playing
                default:
                    break
                }
            case .person:
                contentCategory = .popular
            }
        }

        API.getContent(contentType: contentType!, contentCategory: contentCategory!)
        try! fetchedResultsController.performFetch()
        print(fetchedResultsController.fetchedObjects?.count)
    }

    // MARK: Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}
