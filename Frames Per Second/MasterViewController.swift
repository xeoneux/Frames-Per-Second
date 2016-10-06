//
//  MasterViewController.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITabBarDelegate {

    var contentType: ContentType!

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var tvTab: UITabBarItem!
    @IBOutlet weak var movieTab: UITabBarItem!
    @IBOutlet weak var personTab: UITabBarItem!

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        segmentedControl.removeAllSegments()

        switch item.tag {
        case 0:
            // tv
            segmentedControl.insertSegment(withTitle: "On TV", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "Popular", at: 1, animated: true)
            segmentedControl.insertSegment(withTitle: "Top Rated", at: 2, animated: true)
            segmentedControl.insertSegment(withTitle: "Airing Today", at: 3, animated: true)
        case 1:
            // movie
            segmentedControl.insertSegment(withTitle: "Popular", at: 0, animated: true)
            segmentedControl.insertSegment(withTitle: "Upcoming", at: 1, animated: true)
            segmentedControl.insertSegment(withTitle: "Top Rated", at: 2, animated: true)
            segmentedControl.insertSegment(withTitle: "Now Playing", at: 3, animated: true)
        case 2:
            // person
            segmentedControl.insertSegment(withTitle: "Popular", at: 0, animated: true)
        default:
            break
        }

        segmentedControl.selectedSegmentIndex = 0
        selectCategory(segmentedControl)
    }
    
    @IBAction func selectCategory(_ sender: UISegmentedControl) {
        print("Selected Segment Control: ", sender.titleForSegment(at: sender.selectedSegmentIndex)!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
