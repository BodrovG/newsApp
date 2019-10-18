//
//  ImageService.swift
//  newsApp
//
//  Created by Georgy Bodrov on 12/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

protocol Cancelable: AnyObject {
    
    func cancel()
}

class ImageService {
    
    let news: News
    
    private static let cache = NSCache<NSString, NSData>()
    
    init(news: News) {
        self.news = news
    }
    
    static func getImage(
        withURL url: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancelable? {
        
        if let dataImage = cache.object(forKey: url as NSString) {
            completion(.success(dataImage as Data))
            return nil
        } else {
            return downloadImage(withURL: url, completion: completion)
        }
    }
    
    private static func downloadImage(
        withURL url: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancelable? {
        
        guard let url = URL(string: url) else {
            completion(.failure(APIError.wrongURL))
            return nil
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            
            if let data = data {
                cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
            
        }
        dataTask.resume()
        return dataTask
    }
}

extension URLSessionDataTask: Cancelable { }
