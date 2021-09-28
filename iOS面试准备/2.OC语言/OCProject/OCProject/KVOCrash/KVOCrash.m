//
//  KVOCrash.m
//  OCProject
//
//  Created by Danny on 2021/9/28.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "KVOCrash.h"
#import "KVC.h"

@implementation KVOCrash


- (void)test {
    KVC *obj = [KVC new];
    
    [obj addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [obj setValue:@1 forKey:@"age"];
    
    /*
     Be sure to invoke this method (or removeObserver:forKeyPath:context:) before any object specified in addObserver:forKeyPath:options:context: is deallocated.
     */
    [obj removeObserver:self forKeyPath:@"age"];
    
    // 观察者的声明周期结束，调用dealloc之前，观察的内容已经先一步释放了。造成add和remove匹配不上
}

@end
