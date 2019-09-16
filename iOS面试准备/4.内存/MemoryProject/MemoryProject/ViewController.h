//
//  ViewController.h
//  MemoryProject
//
//  Created by Danny on 2019/9/16.
//  Copyright © 2019 Danny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController

///不可变对象最好是用copy修饰，能保证无论如何copy过来的都是不可变对象，且不会被修改。
///可变对象只能用strong修饰，因为无论copy，mutablecopy都会是不可变对象
@property (copy) NSMutableArray *array;

@property (strong) NSTimer *timer;

@end

