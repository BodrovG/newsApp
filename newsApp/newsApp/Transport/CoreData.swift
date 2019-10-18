//
//  CoreData.swift
//  newsApp
//
//  Created by Georgy Bodrov on 16.10.2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation
import CoreData

protocol StorageProtocol {
    
    func addNewsOnCoreData(model: NewsResponse, completion: @escaping (Result<[News], Error>) -> Void)
    func addImageForNews(model: NewsResponse, completion: @escaping (Result<[News], Error>) -> Void)
}

class Storage: StorageProtocol {
    
    private var container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        
        self.container = container
        
    }
    
    func addNewsOnCoreData(
        model: NewsResponse,
        completion: @escaping (Result<[News], Error>) -> Void
    ) {
        
        let arrayNews = model.news
        
        DispatchQueue.main.async {
            
            for jsonNews in arrayNews {
                let news = DBNews(context: self.container.viewContext)
                news.title = jsonNews.title
                news.descriptionText = jsonNews.description
                news.urlArticle = jsonNews.urlArticle
                news.urlImage = jsonNews.urlImage
                news.image = nil
            }
            self.saveContext()
            self.loadSavedData(model: arrayNews,completion: completion)
        }
        
    }
    
    func addImageForNews(
        model: NewsResponse,
        completion: @escaping (Result<[News], Error>) -> Void
    ) {
        
        let arrayNews = model.news
        
        DispatchQueue.main.async {
            
            for jsonNews in arrayNews {
                let news = DBNews(context: self.container.viewContext)
                news.title = jsonNews.title
                news.descriptionText = jsonNews.description
                news.urlArticle = jsonNews.urlArticle
                news.urlImage = jsonNews.urlImage
                news.image = nil
            }
            self.saveContext()
            self.loadSavedData(model: arrayNews,completion: completion)
        }
        
    }
    
    
}

private extension Storage {
    private func loadSavedData(
        model: [News],
        completion: @escaping (Result<[News], Error>) -> Void
    ) {
        
        let request = DBNews.createFetchRequest()
        
        do {
            let newsRequest = try container.viewContext.fetch(request)
            
            let filteredNews = newsRequest.filter { result in
                model.contains{
                    $0.urlArticle == result.urlArticle
                }
            }
            
            let news = filteredNews.compactMap{ self.createNews(from: $0) }
            print("Got \(filteredNews.count) news")
            completion(.success(news))
        } catch {
            completion(.failure(error))
        }
        
    }
    
    private func createNews(from model: DBNews) -> News? {
        guard let title = model.title else { return nil }
        guard let description = model.descriptionText else { return nil }
        guard let imageURL = model.urlImage else { return nil }
        guard let urlArticle = model.urlArticle else { return nil }
        
        
        let news = News(title: title, description: description, urlImage: imageURL, urlArticle: urlArticle, image: model.image)
        
        return news
    }
    
    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}
