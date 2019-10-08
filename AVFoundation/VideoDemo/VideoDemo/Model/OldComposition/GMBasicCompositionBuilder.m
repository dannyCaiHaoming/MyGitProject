//
//  GMBasicCompositionBuilder.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/1.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicCompositionBuilder.h"


@interface GMBasicCompositionBuilder()

@property (nonatomic, strong) NSArray <GMBasicPlayItem *> *playItems;
@property (strong, nonatomic) AVMutableComposition *composition;

@end

@implementation GMBasicCompositionBuilder

- (id)initWithPlayItems:(NSArray <GMBasicPlayItem *> *)playItems{
    if (self = [super init]) {
        self.playItems = [NSArray arrayWithArray:playItems];
    }
    return self;
}



- (nonnull id<GMComposition>)buildComposition {
    self.composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *trackA = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *trackB = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    for (GMVideoPlayItem *playItem in self.playItems) {
        if (playItem.type == kPlayItem_Video) {
            AVAssetTrack *assetTrackA ;
            AVAssetTrack *assetTrackB ;
            if (playItem.videoArray.count > 0) {
                assetTrackA = [playItem.videoArray[0] tracksWithMediaType:AVMediaTypeVideo].firstObject;
                
                AVAssetTrack *c = [playItem.videoArray[0] tracksWithMediaType:AVMediaTypeAudio].firstObject;
                NSLog(@"%@",c);
            }
            if (playItem.videoArray.count > 1) {
                assetTrackB = [playItem.videoArray[1] tracksWithMediaType:AVMediaTypeVideo].firstObject;
            }
            
            if (assetTrackA) {
                [trackA insertTimeRange:playItem.timeRange ofTrack:assetTrackA atTime:playItem.startTime error:nil];
            }
            if (assetTrackB) {
                [trackB insertTimeRange:playItem.timeRange ofTrack:assetTrackB atTime:playItem.startTime error:nil];
            }
        }
    }
    
    return [[GMBasicComposition alloc] initWithComposition:self.composition];
    
}



@end
