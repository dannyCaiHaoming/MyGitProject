//
//  GMTransitionPlayItem.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMTransitionPlayItem.h"

@implementation GMTransitionPlayItem

- (PlayItemType)type{
    return kPlayItem_Transition;
}

- (CMTime)durationTime{
    if (self.transitionType != kVideoTransitionType_None) {
        return CMTimeMakeWithSeconds(1, NSEC_PER_SEC);
    }
    return kCMTimeZero;
}

+ (instancetype)initialTransitionPlayItem{
    GMTransitionPlayItem *item = [GMTransitionPlayItem new];
//    item.transitionType = kVideoTransitionType_Wipe;
    return item;
}



@end
