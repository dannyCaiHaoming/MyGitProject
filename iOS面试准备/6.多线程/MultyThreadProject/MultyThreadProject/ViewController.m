//
//  ViewController.m
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2019/9/19.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController.h"
#import "UserCenter.h"
#import "GroupObject.h"
#import "GCD.h"
#import "Lock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	//MARK: 1.一个队列对应一个线程
	
	/*
	 一个队列对应一个线程的，就是最简单了，就是一个窗口对应一个队伍，每次只能处理一个任务，新来的就得排到队伍最后面。
	 
	 */
	
//	[self MainThread];
	
	/*
	 
	 一个队列对应两个线程，就是两个窗口，一条队伍。
	 因此，如果有窗口空闲的时候，就会在队伍中找任务处理
	 但是还是要保持先来后到的顺序，新来的也只能排到队伍最后面
	 
	 */
	
	//MARK: 2.一个队列对应两个线程
	
//	[self MainThread2];
	
	//MARK: 3.两个队列对应一个线程
	
//	[self MainThread3];
	
	//MARK: 4.两个队列对应两个线程
	
//	[self MainThead4];
	
	//MARK: 5.串行队列异步执行内同步执行
//	[self SerialThread];
	
	//MARK: 6.栅栏异步调用多读单写  -- 异步写操作
	//可以实现多个不同线程可以同时读取
	//但是写操作只能先后读取
	
//	UserCenter *center = [[UserCenter alloc] init];
//
//	[center objectForKey:@"123"];
//	[center setValue:@"123" forKey:@"123"];
//	[center objectForKey:@"123"];
	

	
	
//	//MARK: 7.全局队列异步任务
//	[self GlobalQueue];
	
	
	//MARK: 8.同步栅栏调用  -- 同步写操作
//	[self BarrierUse];
	
	
	//MARK: 9.dispatch_group使用
//	GroupObject *gObject = [[GroupObject alloc] init];
//	[gObject useGroup];
	
	
//    dispatch_queue_t queue = dispatch_queue_create("com.bestswifter.queue", nil);
//    dispatch_async(queue, ^{
//        NSLog(@"current thread = %@", [NSThread currentThread]);
//		
//		//1.
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            NSLog(@"current thread = %@", [NSThread currentThread]);
//        });
//		//2
//		dispatch_sync(queue, ^{
//			NSLog(@"current thread = %@", [NSThread currentThread]);
//		});
//		
//		
//		//思想：`sync`,`async`换种说法，就是需不需要执行完block内容，才继续下文
//		
//		//1不会队列堵塞的原因是，虽然下文需要等block执行完，但是切换到主队列，主队列由主线程完成，不需要等上完`async`异步建立的线程去工作
//		//2由于需要等执行完block的内容才能执行下文，但是目前队列中的任务是上文异步添加进来的任务，因此产生了竞争死锁。
//    });
	
    
//    GCD *gcd = [GCD new];
//    [gcd test5];
    
    Lock *l = [Lock new];
    
    
    [[[NSThread alloc] initWithBlock:^{
        [l remove];
    }] start];
    [[[NSThread alloc] initWithBlock:^{
        [l add];
    }] start];

}


- (void)GetCurrentThread{
	NSLog(@"Thread - %@",[NSThread currentThread]);
}

- (void)MainThread{
	[self GetCurrentThread];
	NSLog(@"任务1");
	NSLog(@"任务2");
}

- (void)MainThread2{
	dispatch_queue_t queue = dispatch_queue_create("队列1", DISPATCH_QUEUE_SERIAL);
	
	dispatch_sync(queue, ^{
		NSLog(@"任务1");
		[self GetCurrentThread];
	});
	
	dispatch_async(queue, ^{
		NSLog(@"任务2");
		[self GetCurrentThread];
	});
	
//	sleep(3);
	NSLog(@"方法执行结束");
	
	
}

- (void)MainThread3{
	dispatch_queue_t queue = dispatch_queue_create("队列2", DISPATCH_QUEUE_SERIAL);
	
	NSLog(@"任务1");
	[self GetCurrentThread];
	
	dispatch_sync(queue, ^{
		sleep(3);
		NSLog(@"任务2");
		[self GetCurrentThread];
	});
	
	NSLog(@"方法执行结束");
	
}

- (void)MainThead4{
	dispatch_queue_t queue = dispatch_queue_create("队列3", DISPATCH_QUEUE_SERIAL);
	
	NSLog(@"任务1");
	[self GetCurrentThread];
	
	dispatch_async(queue, ^{
		sleep(3);
		NSLog(@"任务2");
		[self GetCurrentThread];
	});
	
	NSLog(@"方法执行结束");
	
}


- (void)SerialThread{
	[self GetCurrentThread];
	dispatch_queue_t queue = dispatch_queue_create("队列4", DISPATCH_QUEUE_SERIAL);
	
	dispatch_async(queue, ^{
		[self GetCurrentThread];
		
		dispatch_sync(queue, ^{
			[self GetCurrentThread];
		});
		[self GetCurrentThread];
	});
	[self GetCurrentThread];
	
}

- (void)GlobalQueue{
	dispatch_queue_t queue = dispatch_queue_create("My_Concurrent_queue", DISPATCH_QUEUE_CONCURRENT);//dispatch_get_global_queue(0, 0);
	
	
	for (int i = 0; i<INTMAX_MAX; i++) {
		dispatch_async(queue, ^{
			[self GetCurrentThread];
		});
	}
	

	
//	dispatch_async(queue, ^{
//		[self GetCurrentThread];
//	});
}


- (void)BarrierUse{
	dispatch_queue_t queue = dispatch_queue_create("sync_barrier_queue", DISPATCH_QUEUE_CONCURRENT);
	
	dispatch_async(queue, ^{
		
		NSLog(@"start");
		dispatch_barrier_sync(queue, ^{
			[self GetCurrentThread];
		});
		NSLog(@"end");
		
	});
}
@end
