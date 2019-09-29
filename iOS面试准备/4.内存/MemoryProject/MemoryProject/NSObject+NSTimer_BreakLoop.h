//
//  NSObject+NSTimer_BreakLoop.h
//  MemoryProject
//
//  Created by 蔡浩铭 on 2019/9/29.
//  Copyright © 2019 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NSTimer_BreakLoop)

+ (NSTimer *)chm_scheduledTimerWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)selector repeat:(BOOL)repeats;


@end

NS_ASSUME_NONNULL_END
