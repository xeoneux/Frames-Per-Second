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

    static func getContent(contentType: ContentType, contentCategory: ContentCategory) {
        let url = "\(api_url)/\(contentType)/\(contentCategory)?api_key=\(api_key)"

        let session = URLSession.shared

        let contentTask = session.dataTask(with: URL(string: url)!, completionHandler: {

            guard $0.2 == nil else {
                fatalError("Error: Unable to get content...")
            }

            let data = try! JSONSerialization.jsonObject(with: $0.0!, options: .allowFragments)

            print(data)
        })

        contentTask.resume()
    }
}
