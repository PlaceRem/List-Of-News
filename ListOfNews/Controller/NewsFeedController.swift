//
//  ViewController.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 14/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

class NewsFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var news = [News]()
    var filteredNews = [News]()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск новостей"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.shared.downloadNewsFromServer { (news) in
            self.news = news
            self.filteredNews = self.news
            self.collectionView.reloadData()
        }

        navigationItem.title = "News feed"
    
        collectionView.backgroundColor = UIColor.white
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        setupSearchBar()
    }
    
    fileprivate func setupSearchBar() {
        navigationController?.navigationBar.addSubview(searchBar)
        
        guard let navBar = navigationController?.navigationBar else { return }
        
        searchBar.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 4).isActive = true
        searchBar.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: 16).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -4).isActive = true
        searchBar.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -16).isActive = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.filteredNews = self.news
        } else {
            self.filteredNews = self.news.filter({ (news) -> Bool in
                return news.title?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        
        self.collectionView.reloadData()
        
        if self.filteredNews.count > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        
        self.filteredNews = self.news
        self.collectionView.reloadData()
        
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

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
}
