//
//  GroupObject.m
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2019/9/24.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GroupObject.h"

@implementation GroupObject

- (instancetype)init{
	if (self = [super init]) {
		
		queue = dispatch_queue_create("group_queue", DISPATCH_QUEUE_CONCURRENT);
		group = dispatch_group_create();
		
		array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",];
		
	}
	return self;
}

- (void)useGroup{
	for (NSString *str in array) {
		dispatch_group_async(group, queue, ^{
			NSLog(@"%@",str);
		});
	}
	
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		NSLog(@"done");
	});
}

@end
