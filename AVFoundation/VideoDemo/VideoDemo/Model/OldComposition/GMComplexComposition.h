//
//  GMComplexComposition.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/14.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMComposition.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMComplexComposition : NSObject<GMComposition>

@property (strong, readonly, nonatomic) AVComposition *composition;

+ (instancetype)compositionWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion;
- (instancetype)initWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion;

@end

NS_ASSUME_NONNULL_END
