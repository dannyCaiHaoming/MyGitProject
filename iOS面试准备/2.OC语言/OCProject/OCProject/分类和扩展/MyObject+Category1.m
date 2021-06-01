//
//  MyObject+Category1.m
//  OCProject
//
//  Created by 蔡浩铭 on 2021/6/1.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "MyObject+Category1.h"

@implementation MyObject (Category1)

+ (void)load {
    NSLog(@"MyObject+Category1 load");
}

+ (void)initialize {
    NSLog(@"MyObject+Category1 initialize");
}

- (void)printTest {
    NSLog(@"MyObject+Category1");
}

+ (void)Category1_Test {
    NSLog(@"Category1_Test");
}


@end
