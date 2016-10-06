//
//  API.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import UIKit

enum ContentCategory: String {
    case popular
    case upcoming
    case top_rated
    case on_the_air
    case now_playing
    case airing_today
}

struct API {

    static let api_key = ""
    static let api_url = "https://api.themoviedb.org/3"
    static let image_url = "https://image.tmdb.org/t/p/w500/"

    static func getContent(contentType: ContentType, contentCategory: ContentCategory) {
        let url = "\(api_url)/\(contentType)/\(contentCategory)?api_key=\(api_key)"

        let session = URLSession.shared

        let contentTask = session.dataTask(with: URL(string: url)!, completionHandler: {

            guard $0.2 == nil else {
                fatalError("Error: Unable to get content...")
            }

            let data = try! JSONSerialization.jsonObject(with: $0.0!, options: .allowFragments)
            let context = CoreDataStackManager.sharedInstance().managedObjectContext
            let results = (data as! [String: Any])["results"] as! [[String: Any]]

            for result in results {
                switch contentType {
                case .tv:
                    Tv(data: result, category: contentCategory.rawValue ,insertInto: context)
                case .movie:
                    Movie(data: result, category: contentCategory.rawValue ,insertInto: context)
                case .person:
                    Person(data: result, category: contentCategory.rawValue ,insertInto: context)
                }
            }

            CoreDataStackManager.sharedInstance().saveContext()
        })

        contentTask.resume()
    }
}
