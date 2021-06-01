//
//  NSObject.m
//  OCProject
//
//  Created by 蔡浩铭 on 2021/5/30.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "MyObject.h"
#import "MyObject+Category1.h"


//@interface MyObject (MyAddition)
//
//
//@property (readwrite, assign, nonatomic) BOOL isTest;
//
///// 此处等于私有方法。
//- (void)printTest;
//+ (void)ClassMethod;
//
//@end
//
//@implementation MyObject(MyAddition)
//
//- (void)printTest {
//    NSLog(@"MyAddition - %d",self.isTest);
//}
//
//+ (void)ClassMethod {
//    NSLog(@"ClassMethod");
//}
//
//
//@end


@implementation MyObject


- (void)printTest {
    NSLog(@"MyObject");
}

//- (void)doSomeThing {
////    [MyObject ClassMethod];
////    [self printTest];
//}

+ (void)load {
    NSLog(@"MyObject load");
    [MyObject Category1_Test];
}

/*
 +load
 会在程序第一次加载到内存的时候，main函数执行前调用，且只会执行一次。与这个类是否使用到无关。
 
 1.load方法执行的顺序是`根类-父类-子类-分类`
 2.该方法不会继承
 3.不需要调用[super load]
 
 */

+ (void)initialize {
    NSLog(@"MyObject initialize");
}

/*
 +initialize
 会在对象创建的时候调用一次，就是懒加载的机制。并且只会执行一次。
 1.initialize的执行顺序是`根类-父类-子类`，如果分类重写了，则会被覆盖
 2.该方法会被继承
  3.不需要调用[super initialize]
 */

@end
