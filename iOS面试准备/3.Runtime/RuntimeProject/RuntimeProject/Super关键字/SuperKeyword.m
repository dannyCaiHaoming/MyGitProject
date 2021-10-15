//
//  SuperKeyword.m
//  RuntimeProject
//
//  Created by 蔡浩铭 on 2021/10/15.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "SuperKeyword.h"



@implementation SuperKeyword

- (void)log {
    [super log];
}

- (void)test {
    
    NSLog(@"[self class] = %@", [self class]); // SuperKeyword
    NSLog(@"[self superclass] = %@", [self superclass]); // SuperKeywordFather
    NSLog(@"--------------------------------");
    NSLog(@"[super class] = %@", [super class]); // SuperKeyword
    NSLog(@"[super superclass] = %@", [super superclass]); // SuperKeywordFather
    
}

@end
