//
//  NSObject.m
//  OCProject
//
//  Created by 蔡浩铭 on 2021/5/30.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "MyObject.h"


@interface MyObject (MyAddition)


@property (readwrite, assign, nonatomic) BOOL isTest;

/// 此处等于私有方法。
- (void)printTest;
+ (void)ClassMethod;

@end

@implementation MyObject(MyAddition)

- (void)printTest {
    NSLog(@"MyAddition - %d",self.isTest);
}

+ (void)ClassMethod {
    NSLog(@"ClassMethod");
}


@end


@implementation MyObject


- (void)printTest {
    NSLog(@"MyObject - %d",self.isTest);
}

- (void)doSomeThing {
    [MyObject ClassMethod];
    [self printTest];
}

@end
