//
//  GCD.m
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2019/9/24.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GCD.h"

@implementation GCD

- (void)showGCD{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSLog(@"123");
	});
}

@end
