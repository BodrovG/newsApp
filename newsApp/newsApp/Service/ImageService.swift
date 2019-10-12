//
//  ImageService.swift
//  newsApp
//
//  Created by Georgy Bodrov on 12/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

class ImageService {
    
    private static let cache = NSCache<NSString, UIImage>()
    
    static func getImage(withURL url: String, completion: @escaping (Result<UIImage, Error>) -> Void){
        if let image = cache.object(forKey: url as NSString) {
            completion(.success(image))
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
    
    private static func downloadImage(withURL url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(APIError.wrongURL))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(.success(downloadedImage!))
            }
        }
        dataTask.resume()
    }
}
