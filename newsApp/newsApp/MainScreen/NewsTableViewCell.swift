//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

struct NewsTableViewCellConfiguration {
    
    let title: String
    let description: String
    let urlImage: String
    
    
}

final class NewsTableViewCell: UITableViewCell {

    lazy var newsImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleView: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        return textLabel
    }()
    
    private lazy var descriptionView: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        addConstraints()
        
    }
    
    
    func configure(configuration: NewsTableViewCellConfiguration) {
        titleView.text = configuration.title
        descriptionView.text = configuration.description
        
    }
    
    private func addConstraints() {
        
        newsImageView.pinToSuperview(superview: self, top: 20, right: -16, left: 16, height: 200, width: nil)
        
        titleView.pinToSuperview(superview: self, left: 16)
        titleView.topAnchor.constraint(equalToSystemSpacingBelow: newsImageView.bottomAnchor, multiplier: 5).isActive = true
        
        descriptionView.pinToSuperview(superview: self, right: -16, bottom: -12, left: 16)
        descriptionView.topAnchor.constraint(equalToSystemSpacingBelow: titleView.bottomAnchor, multiplier: 4).isActive = true
    }
}