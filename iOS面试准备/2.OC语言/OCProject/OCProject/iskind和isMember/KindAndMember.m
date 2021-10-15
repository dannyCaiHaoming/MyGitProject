//
//  KindAndMember.m
//  OCProject
//
//  Created by 蔡浩铭 on 2021/8/8.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "KindAndMember.h"
#import <objc/runtime.h>
@interface Thing : NSObject

@end

@implementation Thing

@end

@implementation KindAndMember

- (void)doSomeThings{

    Thing *t = [Thing new];
    
    
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[Thing class] isKindOfClass:[Thing class]];
    BOOL res4 = [(id)[Thing class] isMemberOfClass:[Thing class]];
    
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
    
    id kind = [KindAndMember new];
    NSLog(@"%d", [kind isMemberOfClass:[kind class]]);  //1
    NSLog(@"%d", [kind isMemberOfClass:[NSObject class]]); //0
    NSLog(@"%d", [kind isKindOfClass:[KindAndMember class]]); //1
    NSLog(@"%d", [kind isKindOfClass:[NSObject class]]); //1
    
    
    NSLog(@"%d", [KindAndMember isMemberOfClass:object_getClass([KindAndMember class])]);  //1
     NSLog(@"%d", [KindAndMember isMemberOfClass:object_getClass([NSObject class])]); //0
//    ********************************
//    传入的不是元类对象
//    ********************************
     NSLog(@"%d", [KindAndMember isMemberOfClass:[NSObject class]]); //0
     NSLog(@"%d", [KindAndMember isKindOfClass:object_getClass([NSObject class])]); //1
//    ********************************
//    基元类的superclass->基类
//    ********************************
     NSLog(@"%d", [KindAndMember isKindOfClass:[NSObject class]]); //1
    
}

@end
