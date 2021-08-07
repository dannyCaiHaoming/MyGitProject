//
//  Keyword.m
//  OCProject
//
//  Created by Danny on 2021/6/16.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "Keyword.h"
#import <objc/runtime.h>

@interface CopyObject : NSObject<NSCopying,NSMutableCopying>


@end


@implementation CopyObject

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    CopyObject *copy = [[CopyObject allocWithZone:zone]init];
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    CopyObject *copy = [[CopyObject allocWithZone:zone]init];
    return copy;
}


@end

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

@property (nonatomic, copy) NSArray *cArray;

@property (nonatomic, strong) NSArray *sArray;

@property (nonatomic, copy) NSMutableArray *cMArray;

@property (nonatomic, strong) NSMutableArray *sMArray;

/*
 1. copy修饰的永远是InMutabale对象，因此后面想调用mutable方法的时候会crash.
    也正因为copy是InMutable，因此我们修饰不可变属性的时候，使用copy的时候有两点：
    a. 进行的是值复制，即赋值的实例进行改变也不会影响我们持有的对象
    b. 如果是strong的话，外面如果传入的是可变的，当前持有的实例也变成可变的，会改变原来声明的意思。
 */

@end

@implementation Keyword


- (void)keyword {
    
    CopyObject *test = [CopyObject new];
    
    NSLog(@"test = %@",test);
    
//    NSArray *iArray = @[test];
    NSMutableArray <CopyObject*>*mArray = [NSMutableArray arrayWithObjects:test, nil];
    
//    NSLog(@"iArray copy = %@, deepCopy = %@",[iArray copy],[iArray mutableCopy]);
//
//    NSLog(@"mArray copy = %@, deepCopy = %@",[mArray copy],[mArray mutableCopy]);
//
//    return;
    
//    self.cArray = mArray;
//    
//    self.sArray = mArray;
//    
//    NSLog(@"copy = %@, strong = %@",self.cArray,self.sArray);
//    
//    [mArray addObject:@"adf"];
//    
//    NSLog(@"copy = %@, strong = %@",self.cArray,self.sArray);
    
//    NSLog(@"Mcopy = %@, Mstrong = %@",self.cMArray,self.sMArray);
    
    NSLog(@"====== = %@",mArray);
    
    self.cMArray = mArray;
    
    self.sMArray = [mArray copy];
//    self.sMArray = [[NSMutableArray alloc] initWithArray:mArray copyItems:YES];
    
    NSLog(@"Mcopy = %@, Mstrong = %@",self.cMArray,self.sMArray);
    
//    [self.cMArray addObject:@"a"];
    
    [self.sMArray addObject:@"a"];
    
    return;;
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
