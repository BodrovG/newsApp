//
//  News.swift
//  newsApp
//
//  Created by Georgy Bodrov on 13/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

struct News: Decodable {
    let title: String
    let description: String
    let urlImage: String
    let urlArticle: String
    let image: Data?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlImage = "urlToImage"
        case urlArticle = "url"
        case image
    }
}


