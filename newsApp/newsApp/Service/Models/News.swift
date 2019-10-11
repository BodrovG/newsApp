//
//  News.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

struct News: Decodable {
    let totalResults: Int
    let articles: [currentNews]
}

struct currentNews: Decodable {
    let title: String
    let description: String
    let urlToImage: String
    
}
