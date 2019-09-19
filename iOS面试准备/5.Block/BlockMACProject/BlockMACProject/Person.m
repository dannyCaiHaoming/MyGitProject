//
//  Person.m
//  BlockMACProject
//
//  Created by 蔡浩铭 on 2019/9/18.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

/*
 MAC中，block默认的关键字是assign。因此，在函数上下完执行完赋值，使用block之后，这个block就会自动释放，因此可以看做此时的赋值只是普通的“weak”指针持有block。而且这时候block还在栈中，因此也是用完即废弃，不需要程序员去管理。
 但是如果使用了copy方法之后，block会从栈复制到堆中，并且这个时候就需要程序员在合适的时机进行release操作。这个block由栈复制到堆中的时候，引用计数也由1变成了2，由对象持有这个block，若然此时block也持有该对象的时候，就会因此循环引用。
 
 */


#import "Person.h"

@implementation Person


- (void)initBlock {
	
	
	NSLog(@"%p",self);
	NSLog(@"before - %lu",self.retainCount);
	
//	__block Person *blockSelf = self;
	
	NSLog(@"outside = %p,%@",&self,self);
	
	self.testBlock = [^{
		
		//		[self.testBlock release];
		
		//		blockSelf = nil;
		NSLog(@"inside = %p,%@",&self,self);
		
		
	} copy];
	
	NSLog(@"%@",[self.testBlock class]);
	
	NSLog(@"after - %lu",(unsigned long)self.retainCount);
	
	
	NSLog(@"before - %lu",self.retainCount);
	self.obj1 = [[NSObject alloc] init];
	
	
	self.testBlock();
	
	
	
	NSLog(@"after - %lu",(unsigned long)self.retainCount);
	
	
}


- (void)executeBlock{
	self.testBlock();
}


- (void)dealloc {
	[super dealloc];
	NSLog(@"Person dealloc");
}
@end
