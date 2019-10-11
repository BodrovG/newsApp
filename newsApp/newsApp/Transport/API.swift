//
//  API.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

class API {
    func requestModel<Model: Decodable>(parameters: [String:String], completion: @escaping (Result<Model, Error>) -> Void) {
        guard let url = self.baseUrl(params: parameters) else {
            completion(.failure(APIError.wrongURL))
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        print(request)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
}

enum APIError: LocalizedError {
    
    case wrongURL
    case server(Error)
    case emptyResult
    case parsing(Error)
    
    var errorDescription: String? {
        switch self {
        case .emptyResult:
            return "Не были получены данные"
        case .parsing(let error):
            return error.localizedDescription
        case .server(let error):
            return error.localizedDescription
        case .wrongURL:
            return "Неверный url"
        }
    }
}

private extension API {
    
    func prepareHeader() -> [String:String]? {
        var headers = [String:String]()
        headers["Authorization"] = "Client-ID 93294ce5e20fe7f8d1c07df19b322b5936af4a9772ce831dc71e635ec83c85bd"
        return headers
    }
    
    func createDataTask<Model: Decodable>(
        from request: URLRequest,
        completion: @escaping (Result<Model, Error>) -> Void
    ) -> URLSessionDataTask  {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(APIError.server(error)))
            }
            
            guard let data = data else {
                completion(.failure(APIError.emptyResult))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(model))
            } catch let error {
                completion(.failure(APIError.parsing(error)))
            }
        }
    }
    
    func baseUrl(params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = "/v2/everything"
        
        //queryItems - берёт все параметры и перконвертирует их в формат, удобный для url-строки
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)
        }
        //return components.url - то, что мы хотим вернуть из всех составных частей
        return components.url!
    }
}
