//
//  ViewController.swift
//  List Of News 2.0
//
//  Created by Denis Kovrigin on 14/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
//    var news: [News] = [ News(thumbnailImageName: "cards", source: "Vmo24.ru", title: "Светлана Лобода устроила скандал в аэропорту «Шереметьево - Вести Подмосковья"),
//                         News(thumbnailImageName: "meduza", source: "News-front.info", title: "Вопреки заявлениям Порошенко, подтвердилась деятельность биолабораторий США на Украине - News Front - новости Донбасса, России, Крыма и Мира в целом!"),
//                         News(thumbnailImageName: "rbk", source: "Mixnews.lv", title: "Развод самого богатого мужчины в мире: ради кого такие жертвы?"),
//                         News(thumbnailImageName: "trump", source: "Championat.com", title: "Погба отдал крутую голевую передачу. Из-за него «МЮ» должен был проигрывать - Чемпионат")]
    
    var news: [News] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNews()
        
        navigationItem.title = "News feed"
    
        collectionView.backgroundColor = UIColor.white
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    func fetchNews() {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=ru&apiKey=1935f6f781ce4d9f87fd7f6bb8b36b40&pagesize=40")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print("Ошибка! ", error!)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                let jsonArticles = json["articles"]
                print(json)
                
                for dictionary in jsonArticles as! [[String: AnyObject]] {
                    let thumbnailImageName = dictionary["urlToImage"] as? String
                    let title = dictionary["title"] as? String
                    
                    let sourceDictionary = dictionary["source"] as! [String: AnyObject]
                    
                    let source = sourceDictionary["name"] as? String
                    
                    self.news.append(News(thumbnailImageUrl: thumbnailImageName, title: title, source: source))
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let jsonError {
                print("Ошибка! ", jsonError)
            }
        }.resume()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! NewsCell
        let news = self.news[indexPath.item]
        //cell.thumbnailImageView.image = UIImage(named: news.thumbnailImageName!)
//        cell.titleLabel.text = news.title
//        cell.sourceLabel.text = news.source
        cell.news = news
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 16, height: 330)
    }
}

struct News {
    var thumbnailImageUrl: String?
    var title: String?
    var source: String?
}
