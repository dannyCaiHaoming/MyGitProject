//
//  GMCompositionService.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/20.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@class GMBasicComposition;
@class GMTransitionComposition;
@class GMVideoPlayItem;
@class GMTransitionPlayItem;
@class GMBasicPlayItem;
@interface GMCompositionService : NSObject

+ (instancetype)shareInstance;


/**
 提供PlayItems材料去合成一个Composition List

 @param playItems 记录视频，过渡效果的数组
 */
- (void)updateComponsitionListWithPlayItems:(NSArray <GMBasicPlayItem *> *)playItems;

/**
 生成可以播放的AVPlayItem数组

 @return 生成可以播放的AVPlayItem数组
 */
- (NSArray <AVPlayerItem *>*)makePlayable;

/**
 根据是否有过渡效果生成一个指定视频的Composition

 @param videoPlayItem 记录视频的PlayItem数据
 @param hasTransition 是否有过渡效果
 @param isFronPosition 过渡效果是否在前头
 @return 视频的Composition
 */
- (GMBasicComposition *)makeVideoCompositionWithVideoPlayItem:(GMVideoPlayItem *)videoPlayItem hasTransition:(BOOL)hasTransition isFrontPosition:(BOOL)isFronPosition;

/**
 根据前，后视频，还有过渡效果，生成一个1s的过渡视频Composition

 @param transitionPlayItem 记录过渡效果的数据
 @param frontVideoPlayItem 前一个视频的PlayItem数据
 @param backVideoPlayItem 后一个视频的PlayItem数据
 @return 生成一个1s的过渡视频Composition
 */
- (GMTransitionComposition *)makeTransitionCompositionWithTransitionPlayItem:(GMTransitionPlayItem *)transitionPlayItem frontVideoPlayItem:(GMVideoPlayItem *)frontVideoPlayItem backVideoPlayItem:(GMVideoPlayItem *)backVideoPlayItem;

@end

NS_ASSUME_NONNULL_END
