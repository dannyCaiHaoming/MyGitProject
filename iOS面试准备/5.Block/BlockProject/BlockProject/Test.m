//
//  Test.m
//  BlockProject
//
//  Created by Danny on 2021/6/20.
//  Copyright © 2021 Danny. All rights reserved.
//

#import "Test.h"

@implementation Test

- (void)test {
    int age = 10;
    
    void (^myBlock)(int,int) = ^(int a,int b){
        NSLog(@"a = %d,b = %d, age = %d",a,b,age);
    };
    
    myBlock(1,5);
}

@end
