//
//  NetworkService.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

protocol INetworkService {
    
    func news(completion: @escaping (Result<News, Error>) -> Void )
    
}

class NetworkService: INetworkService{
    
    func news(completion: @escaping (Result<News, Error>) -> Void ) {
        var parameters = [String:String]()
        parameters["q"] = "bitcoin"
        parameters["apiKey"] = "a84a77df877e48d89ac7c0cfef570d15"
        
        API().requestModel(parameters: parameters, completion: completion)
    }
}
