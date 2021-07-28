//
//  MyViewController.swift
//  UIViewProject
//
//  Created by 蔡浩铭 on 2021/7/9.
//  Copyright © 2021 Danny. All rights reserved.
//

import UIKit


class MyViewController: UIViewController {
    
    
    override func loadViewIfNeeded() {
        print("第4步\(#function)")
//        super.loadViewIfNeeded()
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .yellow
        self.view = v
        print("第1步\(#function)")
    }
    
    override func viewDidLoad() {
        print("第2步\(#function)")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("第3步\(#function)")
        super.viewWillAppear(animated)
    }
    

    
    override func viewWillLayoutSubviews() {
        print("第5步\(#function)")
//        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        print("第6步\(#function)")
//        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("第7步\(#function)")
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("第8步\(#function)")
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("第9步\(#function)")
        super.viewDidDisappear(animated)
    }
    
    
}
