//
//  NewsListViewController.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController, Alert {
    private enum CellIdentifiers {
        static let list = "List"
    }
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorColor = UIColor(red: CGFloat(0), green: CGFloat(104/255.0), blue: CGFloat(55/255.0), alpha: CGFloat(1.0))
        return tv
    }()
//    var indicatorView: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView()
//        indicator.isUserInteractionEnabled = true
//        indicator.hidesWhenStopped = true
//        indicator.startAnimating()
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
    
    
    private var viewModel: NewsViewModel!
    
    private var cancelables: [String: Cancelable] = [:]
    
    private var shouldShowLoadingCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.pinToSuperview(superview: view, top: 0, right: 0, bottom: 0, left: 0)
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
//        tableView.addSubview(indicatorView)
//        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        indicatorView.startAnimating()
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.list)
        
        viewModel = NewsViewModel(delegate: self)
        
        viewModel.fetchNews()
    }
}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! NewsTableViewCell
        cell.configure(with: viewModel.news(at: indexPath.row))
        
        updateImageForCell(cell, inTableView: tableView, atIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelables[viewModel.news(at: indexPath.row).urlImage]?.cancel()
        cancelables[viewModel.news(at: indexPath.row).urlImage] = nil
    }
    
    func updateImageForCell(_ cell: NewsTableViewCell, inTableView tableView: UITableView, atIndexPath indexPath: IndexPath) {
        
        let urlImage = viewModel.news(at: indexPath.row).urlImage
        
        cell.newsImageView.image = UIImage(named: "defaultImage")
        
        let cancelable = ImageService.getImage(withURL: urlImage) { result in
            switch result {
            case .success(let image):
                cell.newsImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
        cancelables[urlImage] = cancelable
        
    }
}

extension NewsListViewController: NewsViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
//        indicatorView.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
//        indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

extension NewsListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchNews()
        }
    }
    
}

private extension NewsListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        let correctIndexPath = indexPath.row + Int(1)
        return correctIndexPath >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
