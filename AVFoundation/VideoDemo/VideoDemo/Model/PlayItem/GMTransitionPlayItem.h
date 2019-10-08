//
//  GMTransitionPlayItem.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicPlayItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    kVideoTransitionType_None,
    kVideoTransitionType_Dissolve,
    kVideoTransitionType_Push,
    kVideoTransitionType_Wipe
} GMVideoTransitionType;

@interface GMTransitionPlayItem : GMBasicPlayItem

///是否起作用
@property (nonatomic, assign) GMVideoTransitionType transitionType;



+ (instancetype)initialTransitionPlayItem;

@end

NS_ASSUME_NONNULL_END
