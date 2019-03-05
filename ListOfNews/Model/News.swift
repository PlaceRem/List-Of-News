//
//  News.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 15/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

struct NNews {
    let url: String?
    let urlToImage: String?
    let title: String?
    let publishedAt: Date?
    let sourceName: String?
    
    // Initializer for news from server
    init(dictionary: [String: Any]) {
        self.url = dictionary["url"] as? String
        self.urlToImage = dictionary["urlToImage"] as? String
        self.title = dictionary["title"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateString = dictionary["publishedAt"] as? String ?? ""
        let publishedAt = dateFormatter.date(from: dateString)
        self.publishedAt = publishedAt
        
        let source = dictionary["source"] as? [String: Any] ?? [:]
        self.sourceName = source["name"] as? String
    }
    
    // Initializer for news from Core Data
    init(newsFromCoreData: News) {
        self.url = newsFromCoreData.url
        self.urlToImage = newsFromCoreData.urlToImage
        self.title = newsFromCoreData.title
        self.publishedAt = newsFromCoreData.publishedAt
        self.sourceName = newsFromCoreData.sourceName
    }
}
