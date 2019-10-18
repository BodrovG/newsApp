//
//  NetworkService.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func news(page: Int, completion: @escaping (Result<[News], Error>) -> Void )
    
}

class NetworkService: NetworkServiceProtocol {
    
    private let api: APIProtocol
    
    init(api: APIProtocol) {
        self.api = api
    }
    
    func news(page: Int, completion: @escaping (Result<[News], Error>) -> Void ) {
        var parameters = [String:String]()
        parameters["q"] = "russia"
        parameters["page"] = "\(page)"
        parameters["apiKey"] = "a84a77df877e48d89ac7c0cfef570d15"
        
        api.requestModel(parameters: parameters, completion: completion)
    }
}
