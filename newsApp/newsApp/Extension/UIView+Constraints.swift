//
//  UIView+Constraints.swift
//  newsApp
//
//  Created by Georgy Bodrov on 11/10/2019.
//  Copyright © 2019 Georgy Bodrov. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinToSuperview(
        superview: UIView, top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil, height: CGFloat? = nil, width: CGFloat? = nil
        ) {
        
        translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        
        if let top = top {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: left).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
}
