//
//  DetailViewController.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var content: Any!
    var contentType: ContentType?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let contentType = contentType {
            switch contentType {
            case .tv:
                let content = self.content as! Tv
                label.text = content.title
                textView.text = content.overview
                imageView.image = UIImage(data: content.imageData as! Data)
            case .movie:
                let content = self.content as! Movie
                label.text = content.title
                textView.text = content.overview
                imageView.image = UIImage(data: content.imageData as! Data)
            case .person:
            let content = self.content as! Person
            label.text = content.name
            textView.text = ""
            imageView.image = UIImage(data: content.imageData as! Data)
            }
        }
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

