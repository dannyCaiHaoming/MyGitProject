//
//  Test.m
//  BlockProject
//
//  Created by Danny on 2021/6/20.
//  Copyright © 2021 Danny. All rights reserved.
//

#import "Test.h"


@interface Test ()

@property (strong ,nonatomic) void (^strongblock) (void);


@end

@implementation Test

- (void)test {
    int age = 10;
    
    void (^myBlock)(int,int) = ^(int a,int b){
        NSLog(@"a = %d,b = %d, age = %d",a,b,age);
    };
    
    myBlock(1,5);
}

- (void)print {
    
    self.strongblock = ^{
        NSLog(@"123");
    };
    
    NSLog(@"strong block = %@",[self.strongblock class]);
    
    void (^nonParams) (void) = ^{
        NSLog(@"123");
    };
    NSLog(@"nonParams = %@",[nonParams class]);
    
    auto NSString *a = @"123";
    
    NSLog(@"nslog = %@",[^{
        NSLog(@"%@",a);
    } class]);
    
    
    void (^autoParams) (void) = ^{
        NSLog(@"autoParams = %@",a);
    };
    NSLog(@"autoParams = %@",[autoParams class]);
    
    void (^selfParams) (void) = ^{
        NSLog(@"selfParams = %@",self);
    };
    NSLog(@"selfParams = %@",[selfParams class]);
 
    
    /*
     ARC中
     1.不截取变量的NSGLobalBlock
     2.截取变量但没有局部变量引用，即不会存在引用增加的可能，仍在是在栈区的block，及还是NSStackBlock
     3.如有引用计数增加，即局部变量或实例变量引用，或者作为函数的返回，都会在堆中开辟空间进行存储，因此此时为
     NSMallocBlock
     
     
     */
}

@end
