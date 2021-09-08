//
//  卡顿检测.m
//  RunLoopProject
//
//  Created by 蔡浩铭 on 2021/9/8.
//  Copyright © 2021 Danny. All rights reserved.
//

#import "CheckStuck.h"


@interface CheckStuck()


@end
@implementation CheckStuck


- (void) beginMonitor {
//    typedef struct {
//        CFIndex    version;
//        void *    info;
//        const void *(*retain)(const void *info);
//        void    (*release)(const void *info);
//        CFStringRef    (*copyDescription)(const void *info);
//    } CFRunLoopObserverContext;
    CFRunLoopObserverContext context = {0,(__bridge  void *)self,NULL,NULL};
    
    //    typedef void (*CFRunLoopObserverCallBack)(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);
    
    
    CFRunLoopObserverRef runloopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0,&runLoopObserverCallback, &context);
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), runloopObserver, kCFRunLoopCommonModes);
    
    self->dispatchSemaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        int i = 0;
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 90 * NSEC_PER_MSEC));
            
            NSLog(@"while%@",@(i++));
            NSLog(@"%lu",self->runloopActivity);
            if (semaphoreWait != 0) {
//                if (!self->runLoopObserver) {
//
//                    return;;
//                }
                if (self->runloopActivity == kCFRunLoopBeforeSources || self->runloopActivity == kCFRunLoopAfterWaiting) {
                    if (++self->timeoutCount < 3) {
                        continue;;
                    }
                    NSLog(@"调试： 检测到卡顿");
                }
            }
            self->timeoutCount = 0;
        }
    });
}

static void runLoopObserverCallback(CFRunLoopObserverRef observer,
                                    CFRunLoopActivity activity,
                                    void *info) {
    
    CheckStuck * checkStuck = (__bridge CheckStuck *)info;
    checkStuck->runloopActivity = activity;
    
    NSLog(@"%lu",activity);
    
    dispatch_semaphore_t semaphore = checkStuck->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

//typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
//    kCFRunLoopEntry = (1UL << 0),
//    kCFRunLoopBeforeTimers = (1UL << 1),
//    kCFRunLoopBeforeSources = (1UL << 2),
//    kCFRunLoopBeforeWaiting = (1UL << 5),
//    kCFRunLoopAfterWaiting = (1UL << 6),
//    kCFRunLoopExit = (1UL << 7),
//    kCFRunLoopAllActivities = 0x0FFFFFFFU
//};

@end
