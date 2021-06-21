//
//  StackHeap.m
//  RuntimeProject
//
//  Created by Danny on 2021/6/20.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "StackHeap.h"

@implementation StackHeap

- (void)test {
    
    
//    id p = [NSObject class];
//    void *pointer = &p;
//
//
//    int a = 14;
//    NSLog(@"%p",&a);
//
//    static int c = 0;
//
//    NSLog(@"%p",&c);
//
    char *leap = (char *)malloc(100);
//    char *leap2 = (char *)malloc(100);
//
    NSLog(@"%p",&(*leap));
//    NSLog(@"%p",&(*leap2));
    
    NSString *a = @"a";
    NSString *b = @"b";
    
    NSString *c = [a stringByAppendingString:b];
    NSString *d = [a stringByAppendingString:b];
    
    
    NSMutableString *aa = [NSMutableString stringWithString:@"123"];
    NSMutableString *bb = [NSMutableString stringWithString:@"123"];
    
    NSLog(@"a = %p,b = %p",&(*a),&(*b));
    NSLog(@"c = %p,d = %p",&(*c),&(*d));
    
    NSLog(@"aa = %p,bb = %p",&aa,&bb);
    NSLog(@"aa = %p,bb = %p",&(*aa),&(*bb));
    
    
//    NSString *str = @"123";
//
//    NSMutableString *mStr = [NSMutableString stringWithString:@"123"];
//
//    NSObject *objc = [NSObject new];
//
//    NSLog(@"str = %p,mstr = %p,obj = %p",&str,&mStr,&objc);
}


//+ (void)initialize {
//    NSLog(@"StackHeap = %p",[StackHeap class]);
//    NSLog(@"NSObject = %p",[NSObject class]);
//}

@end
