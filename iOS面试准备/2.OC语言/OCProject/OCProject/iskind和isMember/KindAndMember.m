//
//  KindAndMember.m
//  OCProject
//
//  Created by 蔡浩铭 on 2021/8/8.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "KindAndMember.h"

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
    
    
}

@end
