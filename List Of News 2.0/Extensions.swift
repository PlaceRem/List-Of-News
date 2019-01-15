//
//  Extensions.swift
//  List Of News 2.0
//
//  Created by Denis Kovrigin on 14/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString as String)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
                
                DispatchQueue.main.async {
                    self.image = UIImage(named: "not-found")
                }
                
                return
            }
            
            DispatchQueue.main.async {
                
                let imageToCache = UIImage(data: data!)
                
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                
                self.image = imageToCache
            }
            }.resume()
    }
}
