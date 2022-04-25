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


/*
 注解：
 1. sync方法：
    a.串行、并行队列都不会创建新线程运行
    b.sync是等block执行完再执行下文，因此如果同个串行队列上下文进行sync操作会死锁！
 2. async方法：
    a.串行、并行队列async都会创建新线程运行，并行队列看运行状态决定上限
    b.不需要等待block执行完，即可执行下文
    c.除了主队列，主队列不会新开线程执行，
 
 
 */

- (void) test1 {
    // 主线程， 串行队列  同步 异步
    dispatch_queue_t queue = dispatch_queue_create("test1", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"async before do");
    dispatch_async(queue, ^{
        NSLog(@"thread = %@",[NSThread currentThread]);
        NSLog(@"async do");
    });
    NSLog(@"async after do");
    
    NSLog(@"sync before do");
    dispatch_sync(queue, ^{
        NSLog(@"thread = %@",[NSThread currentThread]);
        NSLog(@"sync do");
    });
    NSLog(@"sync after do");
}

- (void) test2 {
    // 主线程， 并行队列  同步 异步
    dispatch_queue_t queue = dispatch_queue_create("test2", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"async before do");
    dispatch_async(queue, ^{
        NSLog(@"thread = %@",[NSThread currentThread]);
        NSLog(@"async do");
    });
    NSLog(@"async after do");
    
    NSLog(@"sync before do");
    dispatch_sync(queue, ^{
        NSLog(@"thread = %@",[NSThread currentThread]);
        NSLog(@"sync do");
    });
    NSLog(@"sync after do");
}

/*
 注解：
 嵌套队列，只需要看清楚当前执行队列的串行亦或是并行。
 由于串行队列不会新增线程，只要是在串行队列上下文sync一下，就立刻gg
 */

- (void)test3 {
    // 同步执行 + 并发队列 嵌套  同一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("test3", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        NSLog(@"sync before do");
        dispatch_sync(queue, ^{
            NSLog(@"thread = %@",[NSThread currentThread]);
            NSLog(@"sync do");
        });
        NSLog(@"sync after do");
        
        NSLog(@"async before do");
        dispatch_async(queue, ^{
            NSLog(@"thread = %@",[NSThread currentThread]);
            NSLog(@"async do");
        });
        NSLog(@"async after do");
    });
    
    // 异步执行 + 并发队列 嵌套  同一个并发队列
    dispatch_async(queue, ^{
        NSLog(@"sync before do");
        dispatch_sync(queue, ^{
            NSLog(@"thread = %@",[NSThread currentThread]);
            NSLog(@"sync do");
        });
        NSLog(@"sync after do");
        
        NSLog(@"async before do");
        dispatch_async(queue, ^{
            NSLog(@"thread = %@",[NSThread currentThread]);
            NSLog(@"async do");
        });
        NSLog(@"async after do");

    });
}

- (void)test4 {
    dispatch_queue_t queue = dispatch_queue_create("test4", DISPATCH_QUEUE_SERIAL);
    
    // 同步执行 + 串行队列 嵌套  同一个串行队列
    dispatch_sync(queue, ^{
       
        //串行队列中syns ---  gg
//        NSLog(@"sync before do");
//        dispatch_sync(queue, ^{
//            NSLog(@"thread = %@",[NSThread currentThread]);
//            NSLog(@"sync do");
//        });
//        NSLog(@"sync after do");
        
        NSLog(@"in sync -- async before do");
        dispatch_async(queue, ^{
            NSLog(@"in sync -- thread = %@",[NSThread currentThread]);
            NSLog(@"in sync -- async do");
        });
        NSLog(@"in sync -- async after do");

    });
    
    // 异步执行 + 串行队列 嵌套  同一个串行队列
    dispatch_async(queue, ^{
       
        //串行队列中syns ---  gg
//        NSLog(@"sync before do");
//        dispatch_sync(queue, ^{
//            NSLog(@"thread = %@",[NSThread currentThread]);
//            NSLog(@"sync do");
//        });
//        NSLog(@"sync after do");
        
        NSLog(@"in async -- async before do");
        dispatch_async(queue, ^{
            NSLog(@"in async --  thread = %@",[NSThread currentThread]);
            NSLog(@"in async --  async do");
        });
        NSLog(@"in async --  async after do");

    });
    

}


- (void)test5 {

    dispatch_queue_t queue = dispatch_queue_create("a", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("b", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t global = dispatch_get_global_queue(0, 0);
    
    /*
     async在并发队列上会开启新的线程执行任务。
     1-3里面由于使用串行队列同步，3任务需要等待2结束，2执行的时候使用新的线程去执行，而且也不会卡住全局的并发队列。
     */
//    dispatch_async(global, ^{
//
//        NSLog(@"1- current = %@",[NSThread currentThread]);
//
//        dispatch_sync(queue, ^{
//            NSLog(@"2- current = %@",[NSThread currentThread]);
//        });
//
//        NSLog(@"3- current = %@",[NSThread currentThread]);
//    });
    
    /*
     sync 需要等block执行完才能执行后面。因此4最后。
     1-3，由于使用的是其它队列sync，因此不会循环等待。
     2任务是在queue中分发到queue2，且queue要同步等待完成，才能进行后面。
     且由于queue，queue都是sync，因此都会在主线程上执行。
     */
//    dispatch_sync(queue, ^{
//        NSLog(@"1- current = %@",[NSThread currentThread]);
//        dispatch_sync(queue2, ^{
//            NSLog(@"2- current = %@",[NSThread currentThread]);
//        });
//        NSLog(@"3- current = %@",[NSThread currentThread]);
//    });
    
    /*
     
     */
//    dispatch_async(global, ^{
//        NSLog(@"1- current = %@",[NSThread currentThread]);
//        dispatch_sync(global, ^{
//            NSLog(@"2- current = %@",[NSThread currentThread]);
//        });
//        NSLog(@"3- current = %@",[NSThread currentThread]);
//    });
//
//    NSLog(@"4- current = %@",[NSThread currentThread]);
    
    
    
    /*
     只要在并发队列用一次async，就会开辟一个线程去处理。
     */
    dispatch_async(global, ^{
        NSLog(@"1- current = %@",[NSThread currentThread]);
    });
    
    dispatch_async(global, ^{
        NSLog(@"2- current = %@",[NSThread currentThread]);
    });
}


- (void)test6 {
    
    dispatch_queue_t global = dispatch_get_global_queue(0, 0);
    
    dispatch_async(global, ^{
       
        NSLog(@"1- current = %@",[NSThread currentThread]);
        
        [self performSelector:@selector(printTest6) withObject:nil afterDelay:2];
        
        NSLog(@"3- current = %@",[NSThread currentThread]);
    });
}

- (void)printTest6 {
    NSLog(@"2- current = %@",[NSThread currentThread]);
}


- (void)test7 {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        
    });
    
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
    });
    /*
     可以多次使用notify得到线程同步结束后。
     */
}

@end
