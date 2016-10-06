//
//  MasterViewController.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var contentType: ContentType?

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var tvTab: UITabBarItem!
    @IBOutlet weak var movieTab: UITabBarItem!
    @IBOutlet weak var personTab: UITabBarItem!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
        collectionView.delegate = self
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
        print("Selected Segment Control: ", sender.titleForSegment(at: sender.selectedSegmentIndex)!)

        if let contentType = contentType {
            switch contentType {
            case .tv:
                switch sender.selectedSegmentIndex {
                case 0:
                    API.getContent(contentType: .tv, contentCategory: .popular)
                case 1:
                    API.getContent(contentType: .tv, contentCategory: .top_rated)
                case 2:
                    API.getContent(contentType: .tv, contentCategory: .on_the_air)
                case 3:
                    API.getContent(contentType: .tv, contentCategory: .airing_today)
                default:
                    break
                }
            case .movie:
                switch sender.selectedSegmentIndex {
                case 0:
                    API.getContent(contentType: .movie, contentCategory: .popular)
                case 1:
                    API.getContent(contentType: .movie, contentCategory: .upcoming)
                case 2:
                    API.getContent(contentType: .movie, contentCategory: .top_rated)
                case 3:
                    API.getContent(contentType: .movie, contentCategory: .now_playing)
                default:
                    break
                }
            case .person:
                API.getContent(contentType: .person, contentCategory: .popular)
            }
        }
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
