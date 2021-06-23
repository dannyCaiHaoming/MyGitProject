//
//  Keyword.m
//  OCProject
//
//  Created by Danny on 2021/6/16.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "Keyword.h"
#import <objc/runtime.h>

@interface Keyword ()
/*
 1.  nonatomic  atomic
 2.  strong  copy
 3.  weak  unsafe_unretained
 4.  assign
 5.  readwrite  readonly
 */

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, unsafe_unretained) NSArray *unsafeArray;

//@property (nonatomic, weak) NSArray *weakArray;

//@property (nonatomic, copy) NSString *cString;

@property (nonatomic, strong) NSString *sString;

@property (nonatomic, unsafe_unretained) NSString *unsafeString;



//@property (nonatomic, weak) NSString *weakString;

@property (nonatomic, assign) int integer;

@property (nonatomic, strong) NSObject *sObj;

@property (nonatomic, unsafe_unretained) NSObject *unsafeObj;

//@property (nonatomic, weak) NSObject *weakObj;


@end

@implementation Keyword


- (void)keyword {
    
    // 字符串
    self.sString = @"123";
    
    self.unsafeString = self.sString;
    
//    self.weakString = self.sString;
    
    self.sString = nil;
    
    // 数组
    self.array = [NSArray arrayWithObject:@"123"];
    
    self.unsafeArray = self.array;
    
//    self.weakArray = self.array;
    
    self.array = nil;
    
    // NSObject
    self.sObj = [[NSObject alloc] init];
    
    self.unsafeObj = self.sObj;
    
//    self.weakObj = self.sObj;
    
    self.sObj = nil;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5), dispatch_get_main_queue(), ^{
        [self afterDo];
    });
}

- (void)afterDo {
//    [self.unsafeString boolValue];
    
//    NSLog(@"unsafe--%p;weak--%@",self.unsafeString,self.weakString);
//    NSLog(@"unsafe--%@;weak--%@",self.unsafeArray,self.weakArray);
//    NSLog(@"unsafe--%@;weak--%@",self.unsafeObj,self.weakObj);
}

@end
