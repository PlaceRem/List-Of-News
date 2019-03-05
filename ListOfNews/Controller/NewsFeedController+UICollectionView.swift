//
//  NewsFeedController+UICollectionView.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 19/02/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit
import SafariServices

extension NewsFeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! NewsCell
        let news = self.filteredNews[indexPath.item]
        cell.news = news
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let newsTitle = self.news[indexPath.item].title
        let approximateWidthOfTitleLabel = view.frame.width - 16 - 16 - 20
        let size = CGSize(width: approximateWidthOfTitleLabel, height: 1000)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        
        let estimatedFrame = NSString(string: newsTitle ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: view.frame.width - 16, height: estimatedFrame.height + 234)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? NewsCell {
                cell.transform = .init(scaleX: 0.97, y: 0.97)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? NewsCell {
                cell.transform = .identity
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let newsUrl = self.news[indexPath.item].url else { return }
        
        if let url = URL(string: newsUrl) {
            
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true)
        }
    }
}
