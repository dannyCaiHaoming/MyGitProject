//
//  Person.m
//  RuntimeProject
//
//  Created by 蔡浩铭 on 2019/10/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Man.h"
@implementation Person

void helloworld(void){
	NSLog(@"helloworld1");
}

- (instancetype)init{
    if (self = [super init]) {
        NSLog(@"i am %@",[self class]);
    }
    return self;
}


///动态添加一个方法，YES：让实例重新再次寻找方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{
//	if (sel == NSSelectorFromString(@"helloworld")) {
////		helloworld1();
//		class_addMethod(self, NSSelectorFromString(@"helloworld"), helloworld, "v@:");
//		
//		return YES;
//	}
	return [super resolveInstanceMethod:sel];
}

///返回一个实现了SEL的对象去实现补偿这个方法没找到。
- (id)forwardingTargetForSelector:(SEL)aSelector{
//	if (aSelector == NSSelectorFromString(@"helloworld")) {
//		return  [[Man alloc] init];
//	}
	return [super forwardingTargetForSelector:aSelector];
}

///生成方法签名，然后会生成的执行任务Invocation
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
	if (aSelector == NSSelectorFromString(@"helloworld")) {
		return  [NSMethodSignature signatureWithObjCTypes:"v@:"];
	}else {
		return [super methodSignatureForSelector:aSelector];
	}
}

///为任务指定执行对象，前提是对象有这个SEL方法
- (void)forwardInvocation:(NSInvocation *)anInvocation{
	SEL sel = [anInvocation selector];
	if (sel == NSSelectorFromString(@"helloworld")) {
		Man *man = [[Man alloc] init];
		if ([man respondsToSelector:sel]) {
			[anInvocation invokeWithTarget:man];
		}
	}else{
		[super forwardInvocation:anInvocation];
	}
}
@end
