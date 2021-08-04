//
//  OffScreenView.swift
//  UIViewProject
//
//  Created by 蔡浩铭 on 2021/8/4.
//  Copyright © 2021 Danny. All rights reserved.
//

import Foundation
import UIKit

class OffScreenView: UIView {
    /*
     圆角的作用只会在border和背景
     */
    
    // 背景+圆角
    static func a(_ view: UIView) {
        let v = UIView()
        v.frame = .init(x: 40, y: 100, width: 100, height: 50)
        v.backgroundColor = .blue
        v.layer.cornerRadius = 10
        view.addSubview(v)
    }
    
    // 背景+内容+圆角
    static func b(_ view: UIView) {
        let v = UIImageView(image: UIImage(named: "bg"))
        v.frame = .init(x: 40, y: 150, width: 100, height: 50)
        v.backgroundColor = .blue
        v.layer.cornerRadius = 10
        view.addSubview(v)
    }
    

    
    // 背景+内容+圆角+maskToBounds
    static func c(_ view: UIView) {
        let v = UIImageView(image: UIImage(named: "bg"))
        v.frame = .init(x: 40, y: 200, width: 100, height: 50)
        v.backgroundColor = .blue
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        view.addSubview(v)
    }
    
}
