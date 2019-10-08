//
//  GMComplexCompositionBuilder.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/14.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMComplexCompositionBuilder.h"
#import "GMTransitionPlayItem.h"
#import "GMComplexComposition.h"

static float TransitionTime = 1.0f;
static int32_t TrackID_First = 110;
static int32_t TrackID_Second = 120;

@interface GMComplexCompositionBuilder()

@property (nonatomic, strong) NSArray <GMBasicPlayItem *> *playItems;
@property (strong, nonatomic) AVMutableComposition *composition;

@end

@implementation GMComplexCompositionBuilder

- (id)initWithPlayItems:(NSArray <GMBasicPlayItem *> *)playItems{
    if (self = [super init]) {
        self.playItems = [NSArray arrayWithArray:playItems];
    }
    return self;
}


- (id <GMComposition>)buildComposition{
    
    //用于两个轨道间切换
    BOOL changeRow = NO;
    int selectIndex = 0;
    
    NSMutableArray *transitionPlayItems = [NSMutableArray new];
    
    self.composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionTrackA = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionTrackB = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    NSArray *compositionTrackArray = @[compositionTrackA,compositionTrackB];
    
    //每段视频开始时间
    CMTime cursorTime = kCMTimeZero;
    
    //将视频数据添加到轨道上
    for (GMBasicPlayItem *playItem in self.playItems) {
        if (playItem.type == kPlayItem_Video) {
            //取出Video数据
            AVAsset *asset = [(GMVideoPlayItem *)playItem videoArray].firstObject;
            AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
            
            if (changeRow) {
                //开始时间需要往前挪TransitionTime
                changeRow = NO;
                cursorTime = CMTimeSubtract(cursorTime, CMTimeMakeWithSeconds(TransitionTime, NSEC_PER_SEC));
            }
            
            [compositionTrackArray[selectIndex] insertTimeRange:playItem.timeRange ofTrack:track atTime:cursorTime error:nil];
            
            cursorTime = CMTimeAdd(cursorTime, CMTimeMakeWithSeconds(3, NSEC_PER_SEC));
            
            
            
        }
        if (playItem.type == kPlayItem_Transition) {
            if ([(GMTransitionPlayItem *)playItem transitionType] != kVideoTransitionType_None) {
                changeRow = YES;
                selectIndex = selectIndex == 0 ? 1 : 0;
                [transitionPlayItems addObject:playItem];
            }
        }
    }
    
    
    //根据上面拼好的有过渡片段的轨道，自定义组合指令,过渡效果的组合指令的LayerInstruction数量都是2
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:self.composition];
    
    //用于记录当前使用第几个Transition PlayItem
    int currentTransitionIndex = 0;
    
    changeRow = NO;
    
    for (AVMutableVideoCompositionInstruction *vci in videoComposition.instructions) {
        if (vci.layerInstructions.count == 2) {
            //过渡的PlayItem
            
            GMTransitionPlayItem *playItem = [transitionPlayItems objectAtIndex:currentTransitionIndex];
            
            AVMutableVideoCompositionLayerInstruction *fromLayerInstruction;
            AVMutableVideoCompositionLayerInstruction *toLayerInstruction;
            
            if (changeRow) {
                changeRow = NO;
                fromLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions.lastObject;
                toLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions.firstObject;
            }else{
                changeRow = YES;
                fromLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions.firstObject;
                toLayerInstruction = (AVMutableVideoCompositionLayerInstruction *)vci.layerInstructions.lastObject;
            }
            
            CMTimeRange timeRange = vci.timeRange;
            
            if (playItem.transitionType == kVideoTransitionType_Dissolve) {
                //渐变效果
                [fromLayerInstruction setOpacityRampFromStartOpacity:1.0 toEndOpacity:0.0 timeRange:timeRange];
            }
            
            if (playItem.transitionType == kVideoTransitionType_Push) {
                //向左位移效果
                
                CGSize size = videoComposition.renderSize;
            
                [fromLayerInstruction setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeTranslation(-size.width, 0) timeRange:timeRange];
                
                [toLayerInstruction setTransformRampFromStartTransform:CGAffineTransformMakeTranslation(size.width, 0) toEndTransform:CGAffineTransformIdentity timeRange:timeRange];
                
            }
            
            if (playItem.transitionType == kVideoTransitionType_Wipe) {
                //擦除效果
                CGFloat videoWidth = videoComposition.renderSize.width;
                CGFloat videoHeight = videoComposition.renderSize.height;
                
                CGRect startRect = CGRectMake(0.0f, 0.0f, videoWidth, videoHeight);
                CGRect endRect = CGRectMake(0.0f, videoHeight, videoWidth, 0.0f);
                
                [fromLayerInstruction setCropRectangleRampFromStartCropRectangle:startRect
                                                   toEndCropRectangle:endRect
                                                            timeRange:timeRange];
            }
            
            
            currentTransitionIndex++;
            
            
            
            vci.layerInstructions = @[fromLayerInstruction,toLayerInstruction];
        }
        
        
    }
    
    
    
    
    
    return [[GMComplexComposition alloc] initWithComposition:self.composition videoComposition:videoComposition];
}

@end
//
