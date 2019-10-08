//
//  GMBasicComposition.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicComposition.h"

@interface GMBasicComposition()

@property (strong, nonatomic) AVComposition *composition;

@end

@implementation GMBasicComposition

+ (id)compositionWithComposition:(AVComposition *)composition {
    return [[self alloc] initWithComposition:composition];
}

- (id)initWithComposition:(AVComposition *)composition {
    self = [super init];
    if (self) {
        _composition = composition;
    }
    return self;
}

//- (AVPlayerItem *)makePlayable {                                            // 1
//    return [AVPlayerItem playerItemWithAsset:[self.composition copy]];
//}
//
//- (AVAssetExportSession *)makeExportable {                                  // 2
//    NSString *preset = AVAssetExportPresetHighestQuality;
//    return [AVAssetExportSession exportSessionWithAsset:[self.composition copy]
//                                             presetName:preset];
//}


@end
