//
//  NSObject+NSTimer_BreakLoop.m
//  MemoryProject
//
//  Created by 蔡浩铭 on 2019/9/29.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "NSObject+NSTimer_BreakLoop.h"

@interface NSTimerMiddle : NSObject



@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,weak) id target;

@property (nonatomic, assign) SEL selector;



@end

@implementation NSTimerMiddle



- (instancetype)initTimerMiddleWithTarget:(id) target selector:(SEL)selector {
	
	if (self = [super init]) {
			
		self.target = target;
		self.selector_ = selector;
		self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(middle_timerAction) userInfo:nil repeats:YES];
	}
	return self;

}


- (void)middle_timerAction{
	
	if (self.target == nil) {
		[self.timer invalidate];
		self.timer = nil;
	}else{
		if ([self.target respondsToSelector:self.selector]) {
			[self.target performSelector:self.selector];
		}
		
		NSLog(@"timerAction");
	}
}

@end


@implementation NSObject (NSTimer_BreakLoop)

+ (NSTimer *)chm_scheduledTimerWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)selector repeat:(BOOL)repeats{
	
	NSTimerMiddle *middle = [[NSTimerMiddle alloc] initTimerMiddleWithTarget:target selector:selector];
	
	return middle.timer;
	
}

@end
