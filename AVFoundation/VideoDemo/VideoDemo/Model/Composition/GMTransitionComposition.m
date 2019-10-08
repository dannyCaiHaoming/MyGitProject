//
//  GMTransitionComposition.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/20.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMTransitionComposition.h"


@interface GMTransitionComposition()

@property (strong, nonatomic) AVComposition *composition;
@property (strong, nonatomic) AVVideoComposition *videoComposition;

@end

@implementation GMTransitionComposition
@dynamic composition;


+ (instancetype)compositionWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion{
    return [[GMTransitionComposition alloc] initWithComposition:composition videoComposition:videoCompletion];
}

- (instancetype)initWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion{
    if (self = [super init]) {
        self.composition = composition;
        self.videoComposition = videoCompletion;
    }
    return self;
}

@end
