//
//  News.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 15/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

struct JSONRequest: Decodable {
    let status: String
    let totalResults: Int
    let articles: [JSONNews]
}

struct JSONNews: Decodable {
    let url: String
    let urlToImage: String?
    let title: String
    let source: JSONSource
    let publishedAt: String
}

struct JSONSource: Decodable {
    let id: String?
    let name: String
}
