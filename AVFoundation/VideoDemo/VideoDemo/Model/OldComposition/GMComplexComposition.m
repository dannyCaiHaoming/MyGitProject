//
//  GMComplexComposition.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/14.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMComplexComposition.h"

@interface GMComplexComposition()

@property (strong, nonatomic) AVComposition *composition;
@property (strong, nonatomic) AVVideoComposition *videoComposition;

@end

@implementation GMComplexComposition




+ (instancetype)compositionWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion{
    return [[GMComplexComposition alloc] initWithComposition:composition videoComposition:videoCompletion];
}

- (instancetype)initWithComposition:(AVComposition *)composition videoComposition:(AVVideoComposition *)videoCompletion{
    if (self = [super init]) {
        self.composition = composition;
        self.videoComposition = videoCompletion;
    }
    return self;
}


- (AVPlayerItem *)makePlayable {
    
    AVPlayerItem *playerItem =
    [AVPlayerItem playerItemWithAsset:[self.composition copy]];
    
    playerItem.videoComposition = self.videoComposition;
//    playerItem.audioMix = self.audioMix;
    

    
    return playerItem;
}



@end
