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

protocol NewsViewModelProtocol{
    
    func news(at index: Int) -> News
    func fetchNews()
    func setDelegate(delegate: NewsViewModelDelegate)
    func loadImage(_ news: News, _ completion: @escaping (Result<Data, Error>) -> Void)
    func cancelImageLoading(_ news: News)
    
    var currentCount: Int { get }
    
}

final class NewsViewModel: NewsViewModelProtocol {
    weak var delegate: NewsViewModelDelegate?
    
    private var news: [News] = []
    private var currentPage = 1
    private var isFetchInProgress = false
    
    private let networkService: NetworkServiceProtocol
    
    private var imageRequestCancelables: [String: Cancelable] = [:]
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func setDelegate(delegate: NewsViewModelDelegate) {
        self.delegate = delegate
    }
    
    var currentCount: Int {
        return news.count
    }
    
    func news(at index: Int) -> News {
        return news[index]
    }
    
    func loadImage(_ news: News, _ completion: @escaping (Result<Data, Error>) -> Void) {
        let url = news.urlImage
        imageRequestCancelables[url] = ImageService.getImage(withURL: url, completion: completion)
    }
    
    func cancelImageLoading(_ news: News) {
        imageRequestCancelables[news.urlImage]?.cancel()
        imageRequestCancelables[news.urlImage] = nil
    }
    
    func fetchNews() {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        networkService.news(page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.localizedDescription )
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    self.news.append(contentsOf: response)
                    
                    
                    if self.currentPage != 2 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response)
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
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
        
    }
}
