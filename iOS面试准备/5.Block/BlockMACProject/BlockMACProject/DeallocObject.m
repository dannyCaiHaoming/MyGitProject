//
//  DeallocObject.m
//  BlockMACProject
//
//  Created by 蔡浩铭 on 2021/10/11.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "DeallocObject.h"

@implementation DeallocObject


- (void)dealloc {
    NSLog(@"dealloc");
    [super dealloc];
}

@end
