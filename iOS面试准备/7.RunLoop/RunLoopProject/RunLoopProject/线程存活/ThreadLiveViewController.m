//
//  ThreadLiveViewController.m
//  RunLoopProject
//
//  Created by 蔡浩铭 on 2021/9/14.
//  Copyright © 2021 Danny. All rights reserved.
//

#import "ThreadLiveViewController.h"
#import "LongLifeThread.h"

@interface ThreadLiveViewController ()

@property (nonatomic, strong) LongLifeThread *thread;

@end

@implementation ThreadLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test2];
}


/*
 正常执行完，一个线程会自动释放。
 */
- (void)test1 {
    LongLifeThread * thread = [[LongLifeThread alloc] initWithTarget:self selector:@selector(myThredDo1) object:nil];
    [thread start];
    self.thread = thread;
}

- (void)myThredDo1 {
    
    NSLog(@"%@-----开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@-----结束",[NSThread currentThread]);
//    self->thread = nil;
}

- (void)test2 {
    
    LongLifeThread * thread = [[LongLifeThread alloc] initWithTarget:self selector:@selector(startRunLoop) object:nil];
    [thread start];
    self.thread = thread;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self performSelector:@selector(myThredDo1) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)startRunLoop {
    
    NSLog(@"%@",[NSRunLoop currentRunLoop]);
    CFRunLoopObserverRef ob = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;

            default:
                break;
        }
    });

    CFRunLoopAddObserver(CFRunLoopGetCurrent(), ob, kCFRunLoopCommonModes);
//
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
    
    
    //
    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate date]];
    

}
   

@end
