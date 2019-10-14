//
//  NewsResponse.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

struct NewsResponse: Decodable {
    let totalResults: Int
    let news: [News]
    
    enum CodingKeys: String, CodingKey {
        case totalResults
        case news = "articles"
    }
}
