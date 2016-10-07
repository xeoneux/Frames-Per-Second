//
//  API.swift
//  Frames Per Second
//
//  Created by Aayush Kapoor on 06/10/16.
//  Copyright © 2016 Aayush Kapoor. All rights reserved.
//

import UIKit

enum ContentType: String {
    case tv
    case movie
    case person
}

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
    static let image_url = "https://image.tmdb.org/t/p/w500"

    static func getContent(contentType: ContentType, contentCategory: ContentCategory, handler: @escaping (_ results: [String: Any]) -> Void) {
        let url = "\(api_url)/\(contentType)/\(contentCategory)?api_key=\(api_key)"

        let session = URLSession.shared

        let contentTask = session.dataTask(with: URL(string: url)!, completionHandler: {

            guard $0.2 == nil else {
                fatalError("Error: Unable to get content...")
            }

            let json = try! JSONSerialization.jsonObject(with: $0.0!, options: .allowFragments)

            let results = (json as! [String: Any])["results"] as! [[String: Any]]

            handler([
                "results": results,
                "contentType": contentType,
                "contentCategory": contentCategory
            ])
        })

        contentTask.resume()
    }

    static func getImage(ext: String, handler: @escaping (_ imageData: Data) -> Void) {
        let url = "\(image_url)/\(ext)"

        let session = URLSession.shared

        let imageTask = session.dataTask(with: URL(string: url)!, completionHandler: {

            guard $0.2 == nil else {
                fatalError("Error: Unable to get image...")
            }

            handler($0.0!)
        })
        
        imageTask.resume()
    }
}
