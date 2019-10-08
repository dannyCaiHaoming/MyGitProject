//
//  GMTransitionComposition.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/20.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicComposition.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMTransitionComposition : GMBasicComposition

//@property (strong, nonatomic) AVComposition *composition;
@property (strong, readonly, nonatomic) AVVideoComposition *videoComposition;


+ (instancetype)compositionWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion;
- (instancetype)initWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion;

@end

NS_ASSUME_NONNULL_END
