//
//  UserCenter.m
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2019/9/24.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "UserCenter.h"

/*
 异步栅栏调用：等待异步队列中的任务执行完，才去执行栅栏调用内容（类比任务组完成后最后再执行最终任务）
 如果使用全局并发队列，则会是相当于异步并发队列执行，同时执行。
 
 
 
 同步栅栏调用：等待同步队列中任务执行完，才去执行栅栏调用内容（相当于串行队列同步执行）
 如果使用全局并发队列，则会是相当于同步异步队列执行，先来后到
 */

@implementation UserCenter

- (instancetype)init{
	if (self = [super init]) {
		
		queue = dispatch_queue_create("read_write_concurrent", DISPATCH_QUEUE_CONCURRENT);
		dictionary = [[NSMutableDictionary alloc] init];
		
	}
	return self;
}

- (id)objectForKey:(NSString *)key{
	__block id obj;
	__weak UserCenter *weakSelf = self;
	dispatch_sync(queue, ^{
		NSLog(@"objectForKey");
		__strong UserCenter *ws = weakSelf;
		obj = [ws->dictionary objectForKey:key];
	});
	return  obj;
}


- (void)setValue:(id)value forKey:(NSString *)key{
	__weak UserCenter *weakSelf = self;
	dispatch_barrier_async(queue, ^{
		NSLog(@"setValue");
		__strong UserCenter *ws = weakSelf;
		[ws->dictionary setValue:value forKey:key];
	});
	

}

@end
