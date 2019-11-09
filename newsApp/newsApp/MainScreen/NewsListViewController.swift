//
//  NewsListViewController.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController, ShowsAlert {
    private enum CellIdentifiers {
        static let list = "List"
    }
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    private var viewModel: NewsViewModelProtocol
    
    init(viewModel: NewsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setDelegate(delegate: self)
        
        tableView.pinToSuperview(superview: view, top: 0, right: 0, bottom: 0, left: 0)
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.list)
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateImageForCell(cell as! NewsTableViewCell, inTableView: tableView, atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? NewsTableViewCell)?.newsImageView.image = UIImage(named: "defaultImage")
        viewModel.cancelImageLoading(viewModel.news(at: indexPath.row))
    }
    
    func updateImageForCell(_ cell: NewsTableViewCell, inTableView tableView: UITableView, atIndexPath indexPath: IndexPath) {
        
        viewModel.loadImage(viewModel.news(at: indexPath.row)) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.newsImageView.image = image
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension NewsListViewController: NewsViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        
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
