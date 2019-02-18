//
//  Extensions.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 14/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

extension UIImageView {
    
    func loadImageUsingUrlString(urlString: String) {
        image = nil
        
        if let imageFromCache = imageCache[urlString] {
            self.image = imageFromCache
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch news image: ", error)
                
                DispatchQueue.main.async {
                    self.image = UIImage(named: "not-found")
                }
                
                return
            }
            
            guard let imageToCache = UIImage(data: data!) else { return }
            
            imageCache[urlString] = imageToCache
            
            DispatchQueue.main.async {
                self.image = imageToCache
            }
        }.resume()
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    }
}

extension Array where Element: News {
    public func containsObject(of news: Element) -> Bool {
        for newsFromArray in self {
            if newsFromArray.title == news.title {
                return true
            }
        }
        
        return false
    }
}
