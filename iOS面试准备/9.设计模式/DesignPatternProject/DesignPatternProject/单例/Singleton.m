//
//  Singleton.m
//  DesignPatternProject
//
//  Created by 蔡浩铭 on 2019/10/21.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "Singleton.h"

static id object = nil;
@implementation Singleton


- (instancetype)shareInstance{
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		object = [[Singleton alloc] init];
	});
	return object;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		object = [super allocWithZone:zone];
	});
	return object;
}

- (id)copyWithZone:(NSZone *)zone{
	return object;
}

@end
