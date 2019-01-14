//
//  NewsCell.swift
//  List Of News 2.0
//
//  Created by Denis Kovrigin on 14/01/2019.
//  Copyright © 2019 Denis Kovrigin. All rights reserved.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rbk")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Теннис. Открытый чемпионат Австралии. Мария Шарапова - Хэрриет Дарт - 6:0, 6:0. Как закончился матч. Теннис - \"Большой шлем\". - СПОРТ - ЭКСПРЕСС"
        //label.font = UIFont(name: "HelveticaNeue-Light", size: 17.0)
        label.font = label.font.withSize(17)
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.text = "Lenta.ru"
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
    
    func setupViews() {
        
        // Shadow Settings
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
