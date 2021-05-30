//
//  NSObject+NSObject_Category.m
//  OCProject
//
//  Created by 蔡浩铭 on 2021/5/30.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "NSObject_Category.h"
#import <objc/runtime.h>

static const NSString *key = @"IsTest";

@implementation NSObject (NSObject_Category)

- (void)setIsTest:(BOOL)isTest {
    return objc_setAssociatedObject(self, CFBridgingRetain(key), [NSNumber numberWithBool:isTest], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isTest {
    NSNumber *number = objc_getAssociatedObject(self, CFBridgingRetain(key));
    return number.boolValue;
}

@end
