//
//  GMBasicPlayItem.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicPlayItem.h"
#import "GMTransitionPlayItem.h"

@implementation GMBasicPlayItem

- (CMTimeRange)timeRange{
    return CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(3, NSEC_PER_SEC));
}


- (BOOL)playItemsDoesTransitions:(NSArray *)playItems{
    for (GMBasicPlayItem *playItem in playItems) {
        if (playItem.type == kPlayItem_Transition) {
            if ([(GMTransitionPlayItem *)playItem transitionType] != kVideoTransitionType_None) {
                return YES;
            }
        }
    }
    return NO;
}

+ (int)playableItemsCount:(NSArray *)playItems{
    int i = 0;
    for (GMBasicPlayItem *playItem in playItems) {
        if (playItem.type == kPlayItem_Video || (playItem.type == kPlayItem_Transition && [(GMTransitionPlayItem *)playItem transitionType] != kVideoTransitionType_None)) {
            i++;
        }
    }
    return i;
}

@end
