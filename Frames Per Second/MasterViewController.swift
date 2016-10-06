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
        print("Selected Tab: " + item.title!)
    }
    
    @IBAction func selectCategory(_ sender: UISegmentedControl) {

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
