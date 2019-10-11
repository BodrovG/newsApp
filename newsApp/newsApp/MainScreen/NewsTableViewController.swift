//
//  NewsTableViewController.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

class NewsTableViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        NetworkService().news() { result in
            switch result {
            case .success(let data):
                print("data = \(data)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
