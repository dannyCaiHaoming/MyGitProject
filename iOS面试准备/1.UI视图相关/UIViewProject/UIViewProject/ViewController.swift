//
//  ViewController.swift
//  UIViewProject
//
//  Created by Danny on 2019/8/29.
//  Copyright © 2019 Danny. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var frameView: UIView = {
        let v = UIView()
        v.backgroundColor = .yellow
        return v
    }()
    
    lazy var boundsView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 绘制流程
        let view = MyView(frame: self.view.bounds)
        self.view.addSubview(view)
        self.view.setNeedsDisplay()
        
        //
//        frame_bounds()
        
        //
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            let vc = MyViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
//        self.view.addSubview(MyView())
        
//        offScreen()
        
    }
    
    

//    override func loadView() {
////        let v = UIView()
////        v.backgroundColor = .green
////        self.view = v
//        /*
//         loadView()的作用是自定义一个viewcontroller的view，然后赋值到viewcontroller上，
//         这个方法重写了但是不做东西会导致控制器多次“重启"
//         */
//    }
    
    func view_button() {
        //继承自UIView,UIResponder
        let a = UILabel()
        //继承自UIControl,UIView,UIResponder
        let b = UIButton()
    }
    
    func frame_bounds() {
        /*
         1.frame是相对父视图的位置
         2.bounds是尺寸和子视图的坐标轴
            a.当修改当前视图bounds的size的时候，调整后的中心仍然为当前视图frame的中心
            b.当修改当前视图bounds的origin的时候，其子视图的对齐就冲这个新的origin开始对齐
         */
        self.view.addSubview(frameView)
        self.view.addSubview(boundsView)
        frameView.frame = CGRect.init(x: 50, y: 100, width: 300, height: 100)
//        boundsView.frame = CGRect.init(x: 50, y: 100, width: 300, height: 100)
        boundsView.bounds = CGRect.init(x: 50, y: 250, width: 300, height: 100)
        
        let a = UIView()
        a.backgroundColor = .black
        a.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        let b = UIView()
        b.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        b.backgroundColor = .black
        
        frameView.addSubview(a)
        boundsView.addSubview(b)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tap(sender:)))
        frameView.addGestureRecognizer(tap)
//        boundsView.addGestureRecognizer(tap)
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        guard let v = sender.view else {
            return
        }
        v.bounds = CGRect.init(x: 100, y: 0, width: 250, height: 50)
        v.subviews.forEach({ print("frame = \($0.frame),bounds = \($0.bounds)")})
        print(v)
    }
    
    
    func offScreen() {
        OffScreenView.a(self.view)
        OffScreenView.b(self.view)
        OffScreenView.c(self.view)
    }
    

}

