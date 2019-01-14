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
        //self.alpha = 0
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            //self.alpha = 1
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error!)
                
                DispatchQueue.main.async {
                    self.image = UIImage(named: "not-found")
                    //self.animateAlphaImage(duration: 0.5)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                
                let imageToCache = UIImage(data: data!)
                
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                
                self.image = imageToCache
                //self.animateAlphaImage(duration: 0.5)
            }
            }.resume()
    }
    
    private func animateAlphaImage(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
}
