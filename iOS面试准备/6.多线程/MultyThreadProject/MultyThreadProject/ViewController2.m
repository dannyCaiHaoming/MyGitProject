//
//  ViewController2.m
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2019/9/24.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@property (nonatomic,strong) NSInvocationOperation *io;
@end

@implementation ViewController2

- (void)dealloc{
	[self.io removeObserver:self forKeyPath:@"ready"];
	[self.io removeObserver:self forKeyPath:@"executing"];
	[self.io removeObserver:self forKeyPath:@"finished"];
	[self.io removeObserver:self forKeyPath:@"cancelled"];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	//MARK:1. 单独使用NSInvocationOperation
//	[self UseInvocationOperation];
	
	//MARK:2. 单独使用NSBlockOperation
//	[self UseBlockOperation];
	
	//MARK:3. addExecutionBlock使用
//	[self AddExecutionBlock];
	
	//MARK:4. 使用NSOperationQueue
	[self UserOperationQueue];
	
	//MARK:5. 添加依赖
//	[self AddDependency];
	
	//MARK:6 线程间通信
	
	
}


- (void)GetCurrentThread{
	NSLog(@"thread--%@",[NSThread currentThread]);
}

- (void)UseInvocationOperation{
	NSInvocationOperation *io = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationAction) object:nil];
	[io start];
}

- (void)UseBlockOperation{
	NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock:^{
		NSLog(@"UseBlockOperation");
		[self GetCurrentThread];
	}];
	[bo start];
}

- (void)invocationAction{
	NSLog(@"invocationAction");
	[self GetCurrentThread];
}

- (void)AddExecutionBlock{
	NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock:^{
		NSLog(@"UseBlockOperation");
		[self GetCurrentThread];
	}];
	
	[bo addExecutionBlock:^{
		NSLog(@"addExecutionBlock");
		//使用了其它线程
		[self GetCurrentThread];
	}];
	[bo start];
	
}

- (void)UserOperationQueue{
	//可以选择使用主队列去执行，也能获取当前队列
	//往OperationQueue添加任务，相当于往并行队列异步执行动作
	//maxConcurrentOperationCount可以将队列控制串行,
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];//[NSOperationQueue mainQueue];
	queue.maxConcurrentOperationCount = 1;//为串行，不设置默认为并行
	
	self.io = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationAction) object:nil];
	
//	@property (readonly, getter=isCancelled) BOOL cancelled;
//	- (void)cancel;
//
//	@property (readonly, getter=isExecuting) BOOL executing;
//	@property (readonly, getter=isFinished) BOOL finished;
//	@property (readonly, getter=isConcurrent) BOOL concurrent; // To be deprecated; use and override 'asynchronous' below
//	@property (readonly, getter=isAsynchronous) BOOL asynchronous API_AVAILABLE(macos(10.8), ios(7.0), watchos(2.0), tvos(9.0));
//	@property (readonly, getter=isReady) BOOL ready;
//
	[self.io addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
	[self.io addObserver:self forKeyPath:@"executing" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial  context:nil];
	[self.io addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial  context:nil];
	[self.io addObserver:self forKeyPath:@"cancelled" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial  context:nil];
	
	

	
	
	[queue addOperation:self.io];
	
	[queue addOperationWithBlock:^{
		
		
		NSLog(@"UseBlockOperation");
		[self GetCurrentThread];
	}];
	
}


- (void)AddDependency{
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	
	
	NSBlockOperation *bo1 = [NSBlockOperation blockOperationWithBlock:^{
		NSLog(@"UseBlockOperation");
		[self GetCurrentThread];
		
		sleep(2);
	}];
	
	NSBlockOperation *bo2 = [NSBlockOperation blockOperationWithBlock:^{
		NSLog(@"UseBlockOperation");
		[self GetCurrentThread];
	}];
	
	[bo2 addDependency:bo1];
	
	[queue addOperation:bo1];
	[queue addOperation:bo2];
	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
	
	if ([object isKindOfClass:[NSInvocationOperation class]]) {
		NSInvocationOperation *io = (NSInvocationOperation *)object;
		NSLog(@"%@---%@---%@",io,keyPath,[io valueForKeyPath:keyPath]);
//		NSLog(@"%@,%@",keyPath,object);
	}
	
}

@end
