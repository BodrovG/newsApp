//
//  NewsViewModel.swift
//  newsApp
//
//  Created by Georgy Bodrov on 13/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import Foundation

protocol NewsViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class NewsViewModel {
    private weak var delegate: NewsViewModelDelegate?
    
    private var news: [News] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let networkService = NetworkService()
    
    init(delegate: NewsViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return news.count
    }
    
    func news(at index: Int) -> News {
        return news[index]
    }
    
    func fetchNews() {
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        // 2
        isFetchInProgress = true
        
        networkService.news(page: currentPage) { result in
            switch result {
            // 3
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.localizedDescription )
                }
            // 4
            case .success(let response):
                DispatchQueue.main.async {
                    // 1
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    // 2
                    self.total = response.totalResults
                    self.news.append(contentsOf: response.news)
                    
                    // 3
                    
                    if self.currentPage != 2 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.news)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newNews: [News]) -> [IndexPath] {
        let startIndex = news.count - newNews.count
        let endIndex = startIndex + newNews.count
        return (startIndex..<endIndex).map { result in
            //delete
            print("result = \(result)")
            return IndexPath(row: result, section: 0) }
    }
    
}
