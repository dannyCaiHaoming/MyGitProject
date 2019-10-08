//
//  GMCompositionService.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/20.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMCompositionService.h"
#import "GMVideoPlayItem.h"
#import "GMTransitionPlayItem.h"
#import "GMBasicComposition.h"
#import "GMTransitionComposition.h"
#import "GMBasicComposition+TitleLayer.h"
#import "AVPlayerItem+THAdditions.h"

static GMCompositionService *service = nil;
static float GMTransitionTime = 1.0f;
static float GMVideoDuration = 3.0f;

@interface GMCompositionService()
{
    //
    CMTime cursorTime;
    //
    int index;
}

@property (nonatomic, strong) NSArray <GMBasicPlayItem *> *playItems;
///用户缓存当前展示的每一段视频Composition，可以增加替换
@property (nonatomic, strong) NSMutableArray <GMBasicComposition *>*compostionList;


@end


@implementation GMCompositionService

+ (instancetype)shareInstance{
    static dispatch_once_t once_token = 0;
    dispatch_once(&once_token, ^{
        if (service == nil) {
            service = [[GMCompositionService alloc] init];
            service.compostionList = [NSMutableArray new];
        }
    });
    return service;
}


- (void)updateComponsitionListWithPlayItems:(NSArray <GMBasicPlayItem *> *)playItems{
    
    //恢复默认数据
    index = 0;
    [self.compostionList removeAllObjects];
    
    self.playItems = [NSArray arrayWithArray:playItems];
    
    NSInteger itemCount = playItems.count;
    
    if (itemCount == 0) {
        return;
    }
    
    for (int i = 0; i < itemCount; i++) {
        GMBasicPlayItem *playItem = playItems[i];
        
        if (playItem.type == kPlayItem_Video ) {
            
            if (i > 1 && playItems[i - 1].type == kPlayItem_Transition && [(GMTransitionPlayItem *)playItems[i - 1] transitionType] != kVideoTransitionType_None) {
                //如果当前playItem是Video PlayItem并且前一个是Transition PlayItem
                [self.compostionList addObject:[self makeVideoCompositionWithVideoPlayItem:(GMVideoPlayItem *)playItem hasTransition:YES isFrontPosition:YES]];
            }else if (playItems[i + 1].type == kPlayItem_Transition && [(GMTransitionPlayItem *)playItems[i + 1] transitionType] != kVideoTransitionType_None){
                //如果当前playItem是Video PlayItem并且后一个是Transition PlayItem
                [self.compostionList addObject:[self makeVideoCompositionWithVideoPlayItem:(GMVideoPlayItem *)playItem hasTransition:YES isFrontPosition:NO]];
            }else{
                //只是简单的视频，前后都没有过渡效果
                [self.compostionList addObject:[self makeVideoCompositionWithVideoPlayItem:(GMVideoPlayItem *)playItem hasTransition:NO isFrontPosition:NO]];
            }
            
            //添加默认的文字图层到Composition
            [self addTitleLayerToVideoComposition:self.compostionList.lastObject];

        }
        
        if (playItem.type == kPlayItem_Transition && [(GMTransitionPlayItem *)playItems[i] transitionType] != kVideoTransitionType_None) {
            //如果PlayItem是Transition PlayItem，并且有过渡效果，才生成Composition，并且加进数组
            [self.compostionList addObject:[self makeTransitionCompositionWithTransitionPlayItem:(GMTransitionPlayItem *)playItem frontVideoPlayItem:(GMVideoPlayItem *)playItems[i - 1] backVideoPlayItem:(GMVideoPlayItem *)playItems[i + 1]]];
        }
        
        
    }
    
    
}


- (void)addTitleLayerToVideoComposition:(GMBasicComposition *)composition{
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = GM720pVideoRect;
    [parentLayer addSublayer:[self makeTextLayer]];
    
    composition.titleLayer = parentLayer;
    
}


- (CALayer *)makeTextLayer {
    
    NSString *text = [NSString stringWithFormat:@"%d : %d",index,index];
    index++;
    
    CGFloat fontSize =  64.0f;
    UIFont *font = [UIFont fontWithName:@"GillSans-Bold" size:fontSize];
    
    NSDictionary *attrs =
    @{NSFontAttributeName            : font,
      NSForegroundColorAttributeName : (id) [UIColor whiteColor].CGColor};
    
    NSAttributedString *string =
    [[NSAttributedString alloc] initWithString:text attributes:attrs];
    
    CGSize textSize = [text sizeWithAttributes:attrs];
    
    CATextLayer *layer = [CATextLayer layer];
    layer.string = string;
    layer.bounds = CGRectMake(0.0f, 0.0f, textSize.width, textSize.height);
    layer.position = CGPointMake(CGRectGetMidX(GM720pVideoRect), 470.0f);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    
    return layer;
}

///
- (GMBasicComposition *)makeVideoCompositionWithVideoPlayItem:(GMVideoPlayItem *)videoPlayItem hasTransition:(BOOL)hasTransition isFrontPosition:(BOOL)isFronPosition{
    
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *assetTrack = [videoPlayItem.videoArray.firstObject tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(3, NSEC_PER_SEC));
    
    if (hasTransition) {
        if (isFronPosition) {
            range = CMTimeRangeMake(CMTimeMakeWithSeconds(GMTransitionTime, NSEC_PER_SEC), CMTimeMakeWithSeconds(GMVideoDuration - GMTransitionTime, NSEC_PER_SEC));
        }else{
            range = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(GMVideoDuration - GMTransitionTime, NSEC_PER_SEC));
        }
    }
    [compositionTrack insertTimeRange:range ofTrack:assetTrack atTime:kCMTimeZero error:nil];
    
    return [GMBasicComposition compositionWithComposition:composition];
}


- (GMTransitionComposition *)makeTransitionCompositionWithTransitionPlayItem:(GMTransitionPlayItem *)transitionPlayItem frontVideoPlayItem:(GMVideoPlayItem *)frontVideoPlayItem backVideoPlayItem:(GMVideoPlayItem *)backVideoPlayItem{
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionTrackA = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *compositionTrackB = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *frontAssetTrack = [frontVideoPlayItem.videoArray.firstObject tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
    AVAssetTrack *backAssetTrack = [backVideoPlayItem.videoArray.firstObject tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
    [compositionTrackA insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(GMVideoDuration - GMTransitionTime, NSEC_PER_SEC), CMTimeMakeWithSeconds(GMTransitionTime, NSEC_PER_SEC)) ofTrack:frontAssetTrack atTime:kCMTimeZero error:nil];
    
    [compositionTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(GMTransitionTime, NSEC_PER_SEC)) ofTrack:backAssetTrack atTime:kCMTimeZero error:nil];
    
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:composition];
    
    for (AVVideoCompositionInstruction *vci in  videoComposition.instructions) {
        
        
        AVMutableVideoCompositionLayerInstruction *fromLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions.firstObject;
        AVMutableVideoCompositionLayerInstruction *toLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions.lastObject;
        
        
        CMTimeRange timeRange = vci.timeRange;
        
        if (transitionPlayItem.transitionType == kVideoTransitionType_Dissolve) {
            //渐变效果
            [fromLayerInstruction setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:timeRange];
        }
        
        if (transitionPlayItem.transitionType == kVideoTransitionType_Push) {
            //向左位移效果
            
            CGSize size = videoComposition.renderSize;
            
            [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-size.width, 0) timeRange:timeRange];
            
            [toLayerInstruction setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(size.width, 0) toEndTransform:CGAffineTransformIdentity timeRange:timeRange];
            
        }
        
        if (transitionPlayItem.transitionType == kVideoTransitionType_Wipe) {
            //擦除效果
            CGFloat videoWidth = videoComposition.renderSize.width;
            CGFloat videoHeight = videoComposition.renderSize.height;
            
            CGRect startRect = CGRectMake(0.0f, 0.0f, videoWidth, videoHeight);
            CGRect endRect = CGRectMake(0.0f, videoHeight, videoWidth, 0.0f);
            
            [fromLayerInstruction setCropRectangleRampFromStartCropRectangle:startRect
                                                          toEndCropRectangle:endRect
                                                                   timeRange:timeRange];
        }
    }
    
    
    return [GMTransitionComposition compositionWithComposition:composition videoComposition:videoComposition];
}

- (NSArray <AVPlayerItem *>*)makePlayable{
    
    NSMutableArray *items = [NSMutableArray new];
    
    //提出Add PlayItem，以及没有过渡效果的Transition PlayItem
    int playableCount = [GMBasicPlayItem playableItemsCount:self.playItems];
    
    for (int i = 0; i < playableCount; i++) {
        GMBasicComposition *gmCompostion = self.compostionList[i];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:gmCompostion.composition];
        if (self.playItems[i].type == kPlayItem_Transition ) {
            GMTransitionPlayItem *transitionPlayItem = (GMTransitionPlayItem *)self.playItems[i];
            if (transitionPlayItem.transitionType != kVideoTransitionType_None) {
                item.videoComposition = [(GMTransitionComposition *)gmCompostion videoComposition];
            }
        }
        
        if (gmCompostion.titleLayer) {
            AVSynchronizedLayer *syncLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:item];
            [syncLayer addSublayer:gmCompostion.titleLayer];
            item.syncLayer = syncLayer;
        }
        
        [items addObject:item];
    }
    return items;
}




@end
