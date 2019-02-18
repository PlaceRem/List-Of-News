//
//  NewsCell.swift
//  ListOfNews
//
//  Created by Denis Kovrigin on 14/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    var news: News? {
        didSet {
            titleLabel.text = news?.title
            sourceLabel.text = news?.sourceName
            
            guard let publishedNewsDate = news?.publishedAt else { return }
            
            dateLabel.text = publishedNewsDate.timeAgoDisplay()
            
            if let thumbnailImageUrl = news?.urlToImage {
                thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
            }
            
            setupShadow()
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "not-found")
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(17)
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "21:29 14/01/2019"
        label.font = label.font.withSize(13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(sourceLabel)
        addSubview(dateLabel)
        
        // Thumbnail Image
        thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        // Title
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        // Source
        sourceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        sourceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        // Date
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    func setupShadow() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.55
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
