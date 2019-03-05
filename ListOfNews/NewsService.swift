//
//  Service.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 30/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit
import CoreData

struct NewsService {
    static let shared = NewsService()
    
    private let apiKey = "1935f6f781ce4d9f87fd7f6bb8b36b40"
    private let country = "ru"
    
    func downloadNewsFromServer(completion: @escaping ([NNews]) -> ()) {
        print("Trying to get news from server...")
        
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=\(country)&apiKey=\(apiKey)&pagesize=40") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            let newsFromCoreData = self.fetchNewsFromCoreData()
            
            if let error = error {
                print("Failed to do the request: ", error)
                
                DispatchQueue.main.async {
                    completion(newsFromCoreData)
                }
                
                return
            }
            
            guard let data = data else { return }
            
            print("   Successfully got news from server")
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any] else { return }
                
                guard let arrayOfNews = json["articles"] as? [[String: Any]] else { return }
                
                // There is all news from server and Core Data
                var newsFromServerAndCoreData = self.convertType(of: arrayOfNews)
                newsFromServerAndCoreData.append(contentsOf: newsFromCoreData)
                
                let sortedNews = self.deleteDuplicates(newsArray: newsFromServerAndCoreData)
                
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
    
    fileprivate func saveToCoreDate(_ newsArray: [NNews]) {
        print("Trying to save news to CoreData...")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        newsArray.forEach { (newsFromArray) in
            
            do {
                let news = News(context: context)
                news.title = newsFromArray.title
                news.urlToImage = newsFromArray.urlToImage
                news.publishedAt = newsFromArray.publishedAt
                news.sourceName = newsFromArray.sourceName
                news.url = newsFromArray.url
                
                try context.save()
            } catch let saveError {
                print("Failed to save in CoreData: ", saveError)
            }
        }
        
        print("Successfully saved news to CoreData")
    }
    
    fileprivate func fetchNewsFromCoreData() -> [NNews] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<News>(entityName: "News")
        
        do {
            let newsFromCoreData = try context.fetch(fetchRequest)
            var convertedNews = [NNews]()
            
            newsFromCoreData.forEach { (newsCD) in
                let news = NNews(newsFromCoreData: newsCD)
                convertedNews.append(news)
            }
            
            return convertedNews
            
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
    
    fileprivate func convertType(of arrayOfNews: [[String: Any]]) -> [NNews] {
        var convertedNews = [NNews]()
        
        print("Trying to decode news from JSON...")
        
        arrayOfNews.forEach { (dictionary) in
            let news = NNews(dictionary: dictionary)
            
            convertedNews.append(news)
        }
        
        print("   Successfully converted news from JSON")
        
        return convertedNews
    }
    
    fileprivate func deleteDuplicates(newsArray: [NNews]) -> [NNews] {
        
        var uniqueNewsArray = [NNews]()
        
        if newsArray.count > 0 {
            newsArray.forEach { (news) in
                if !uniqueNewsArray.containsObject(of: news) {
                    uniqueNewsArray.append(news)
                }
            }
        }
        
        return self.sortNews(uniqueNewsArray)
    }
    
    fileprivate func sortNews(_ newsArray: [NNews]) -> [NNews] {
        var news = newsArray
        
        news.sort { (n1, n2) -> Bool in
            guard let date1 = n1.publishedAt else { return false }
            guard let date2 = n2.publishedAt else { return false }
            
            return date1.compare(date2) == .orderedDescending
        }
        
        return news
    }
}
