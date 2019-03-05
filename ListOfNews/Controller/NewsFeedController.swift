//
//  ViewController.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 14/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

class NewsFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var news = [NNews]()
    var filteredNews = [NNews]()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск новостей"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsService.shared.downloadNewsFromServer { (news) in
            self.news = news
            self.filteredNews = self.news
            self.collectionView.reloadData()
            
            print("\nКОЛИЧЕСТВО НОВОСТЕЙ: \(self.filteredNews.count)\n")
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
        searchBar.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: 23).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -6).isActive = true
        searchBar.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -23).isActive = true
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
}
