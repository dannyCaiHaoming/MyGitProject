//
//  MyCALayer.swift
//  UIViewProject
//
//  Created by Danny on 2019/8/29.
//  Copyright © 2019 Danny. All rights reserved.
//

import UIKit

//TODO: 1.UIView绘制流程

/*
 1.调用setNeedsDisplaye时，不会立即刷新，而是给这个layer打上一个脏标记。
 2.等到runloop即将休眠的时候，才会去进行刷新
    a.先调用CALayer的display方法
    b.如果CALayer的displayer方法会尝试调用layer的delegate的display方法，
    c.如果delegate没有实现display方法，layer会创建一个backing store，
    然后回去调用layer的draw(in crx:)方法，然后将内容填充到backing store上
    d.如果layer的delegate有实现draw(rect)方法，则会将绘制交给代理完成
 */

//TODO: 2.CALayer原生的`display`和delegate的`display`顺序和关系如何？

class MyCALayer: CALayer {
	
    
    /// 绘制第1步
	override func display() {
		super.display()
	}
	
    /// 绘制第3步
	override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
	}
	
	

}

class MyView: UIView {
    override class var layerClass: AnyClass{
        return MyCALayer.self
    }
    
    /// 绘制第2步
    override func display(_ layer: CALayer) {
//        super.display(layer)
    }
    
    /// 绘制第4步
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    

}
