//
//  Service.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 30/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit
import CoreData

struct Service {
    static let shared = Service()
    
    private let apiKey = "1935f6f781ce4d9f87fd7f6bb8b36b40"
    private let country = "ru"
    
    func downloadNewsFromServer(completion: @escaping ([News]) -> ()) {
        print("Trying to get news from server...")
        
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&apiKey=\(apiKey)&pagesize=40") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to do the request: ", error)
            }
            
            guard let data = data else { return }
            
            print("   Successfully got news from server")
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let json = try jsonDecoder.decode(JSONRequest.self, from: data)
                
                let newsFromServer = json.articles
                
                // Convert JSONNews to News (Core Data format)
                let convertedNews = self.convertType(of: newsFromServer)
                
                let sortedNews = self.deleteDuplicates(withNews: convertedNews)
        
                self.deleteNewsFromCoreData()
                self.saveToCoreDate(sortedNews)
                
                DispatchQueue.main.async {
                    completion(sortedNews)
                }
                
            } catch let jsonDecodeErr {
                print("Failed to decode json: ", jsonDecodeErr)
            }
            
        }.resume()
    }
    
    fileprivate func saveToCoreDate(_ newsArray: [News]) {
        print("Trying to save news to CoreData...")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        newsArray.forEach { (newsFromArray) in
            
            let news = News(context: context)
            news.title = newsFromArray.title
            news.urlToImage = newsFromArray.urlToImage
            news.publishedAt = newsFromArray.publishedAt
            news.sourceName = newsFromArray.sourceName
            
            do {
                try context.save()
            } catch let saveError {
                print("Failed to save in CoreData: ", saveError)
            }
        }
        
        print("Successfully saved news to CoreData")
    }
    
    fileprivate func fetchNewsFromCoreData() -> [News] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        
        do {
            let news = try context.fetch(fetchRequest)
            
            return news
            
        } catch let fetchError {
            print("Failed to fetch companies: ", fetchError)
            return []
        }
    }
    
    fileprivate func deleteNewsFromCoreData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: News.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
        } catch let delErr {
            print("Failed to delete objects from Core Data: ", delErr)
        }
    }
    
    fileprivate func convertType(of newsArray: [JSONNews]) -> [News] {
        var convertedNewsArray = [News]()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        print("Trying to decode news from JSON...")
        
        newsArray.forEach { (newsJSON) in
            let news = News(context: context)
            news.title = newsJSON.title
            news.urlToImage = newsJSON.urlToImage
            news.sourceName = newsJSON.source.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            guard let publishedAt = dateFormatter.date(from: newsJSON.publishedAt) else { return }
            
            news.publishedAt = publishedAt
            
            convertedNewsArray.append(news)
        }
        
        print("   Successfully converted news from JSON")
        
        return convertedNewsArray
    }
    
    fileprivate func deleteDuplicates(withNews newsArrayFromServer: [News]) -> [News] {
        // News from Core Data
        var newsArray = self.fetchNewsFromCoreData()
        newsArray.append(contentsOf: newsArrayFromServer)
        
        var sortedNewsArray = [News]()
        
        if newsArray.count > 0 {
            newsArray.forEach { (news) in
                if !sortedNewsArray.containsObject(of: news) {
                    sortedNewsArray.append(news)
                }
            }
        }
        print("\nКОЛИЧЕСТВО НОВОСТЕЙ: \(sortedNewsArray.count)\n")
        
        sortedNewsArray.sort { (n1, n2) -> Bool in
            guard let date1 = n1.publishedAt else { return false }
            guard let date2 = n2.publishedAt else { return false }
            
            return date1.compare(date2) == .orderedDescending
        }
        
        return sortedNewsArray
    }
}
