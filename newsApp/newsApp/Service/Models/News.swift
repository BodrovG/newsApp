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
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlImage = "urlToImage"
        case urlArticle = "url"
    }
    //
    //        init(title: String, description: String, urlImage: String) {
    //          self.title = title
//          self.description = description
//          self.urlToImage = urlImage
//        }
//
//        init(from decoder: Decoder) throws {
//          let container = try decoder.container(keyedBy: CodingKeys.self)
//          let title = try container.decode(String.self, forKey: .title)
//          let description = try container.decode(String.self, forKey: .description)
//          let urlToImage = try container.decode(String.self, forKey: .urlImage)
//            self.init(title: title.html2String, description: description.html2String, urlImage: urlImage.html2String)
//        }

}


