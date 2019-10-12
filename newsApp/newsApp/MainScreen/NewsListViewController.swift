//
//  NewsTableViewController.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

class NewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let newsId = "newsId"
    
    
    
    
    let accountDetails = [
        NewsTableViewCellConfiguration(title: "321312", description: "2312312", urlImage: "https://i.kinja-img.com/gawker-media/image/upload/s--yDtXY-I4--/c_fill,fl_progressive,g_center,h_900,q_80,w_1600/pj5jc9ntilzdb4dfnivl.png" ),
        NewsTableViewCellConfiguration(title: "321312", description: "2312312", urlImage: "https://cdn.vox-cdn.com/thumbor/QjYjrRLVMwCgjZSfE7JjC7URQns=/0x300:3733x2254/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/19253276/1040241490.jpg.jpg"),
        NewsTableViewCellConfiguration(title: "321312", description: "2312312", urlImage: "https://cdn.vox-cdn.com/thumbor/QGTESHfPDVUTY-jW8Qgipcvj7bM=/0x256:2079x1344/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/11539251/square_cash_01.jpeg"),
        NewsTableViewCellConfiguration(title: "321312", description: "2312312", urlImage: "https://o.aolcdn.com/images/dims?thumbnail=1200%2C630&quality=80&image_uri=https%3A%2F%2Fo.aolcdn.com%2Fimages%2Fdims%3Fcrop%3D5000%252C3332%252C0%252C0%26quality%3D85%26format%3Djpg%26resize%3D1600%252C1067%26image_uri%3Dhttps%253A%252F%252Fs.yimg.com%252Fos%252Fcreatr-images%252F2019-09%252Fa83620e0-d0d2-11e9-bffe-e6277dac35e4%26client%3Da1acac3e1b3290917d92%26signature%3D6bdbc38750df299796016091df5e130ecfe24cb2&client=amp-blogside-v2&signature=35c0eea55c31f00b307f6bb2dcb168ab2fec3432"),
        NewsTableViewCellConfiguration(title: "321312", description: "2312312", urlImage: "https://cdn.arstechnica.net/wp-content/uploads/2019/09/GettyImages-1173072296-760x380.jpg"),
        NewsTableViewCellConfiguration(title: "321312", description: "2312312", urlImage: "https://a.fsdn.com/sd/topics/bitcoin_64.png")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: newsId)
        
        tableView.pinToSuperview(superview: view, top: 0, right: 0, bottom: 0, left: 0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountDetails.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: newsId, for: indexPath) as! NewsTableViewCell
        
        updateImageForCell(cell, inTableView: tableView, atIndexPath: indexPath)
        
        cell.configure(configuration: accountDetails[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       return 30
        return UITableView.automaticDimension
    }
    
    func updateImageForCell(_ cell: NewsTableViewCell, inTableView tableView: UITableView, atIndexPath indexPath: IndexPath) {
        
        cell.newsImageView.image = UIImage(named: "defaultImage")

        ImageService.getImage(withURL: accountDetails[(indexPath as NSIndexPath).row].urlImage) { result in
            switch result {
            case .success(let image):
                let g2 = tableView.indexPath(for: cell)?.row
                print(g2)
//                if (tableView.indexPath(for: cell) as NSIndexPath?)?.row == (indexPath as NSIndexPath).row {
                    cell.newsImageView.image = image
//                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

