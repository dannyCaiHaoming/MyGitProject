//
//  卡顿检测.h
//  RunLoopProject
//
//  Created by 蔡浩铭 on 2021/9/8.
//  Copyright © 2021 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckStuck : NSObject
{
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runloopActivity;
    CFRunLoopObserverRef runLoopObserver;
    int timeoutCount;
}


- (void) beginMonitor;


@end

NS_ASSUME_NONNULL_END
