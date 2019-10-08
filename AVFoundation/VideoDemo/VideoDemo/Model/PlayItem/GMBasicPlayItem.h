//
//  GMBasicPlayItem.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    kPlayItem_UnKnown,
    kPlayItem_Video,
    kPlayItem_Transition,
    kPlayItem_Add
} PlayItemType;

@interface GMBasicPlayItem : NSObject

@property (nonatomic, assign) PlayItemType type;
@property (nonatomic, assign) CMTime startTime;
//@property (nonatomic, assign) CMTime durationTime;
//截取的时间开始和持续时间
@property (nonatomic, assign) CMTimeRange timeRange;


- (BOOL)playItemsDoesTransitions:(NSArray *)playItems;

+ (int)playableItemsCount:(NSArray *)playItems;

@end

NS_ASSUME_NONNULL_END
