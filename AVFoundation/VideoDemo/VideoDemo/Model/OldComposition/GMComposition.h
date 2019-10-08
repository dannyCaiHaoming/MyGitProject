//
//  GMComposition.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GMComposition <NSObject>

- (AVPlayerItem *)makePlayable;
- (AVAssetExportSession *)makeExportable;

@end

NS_ASSUME_NONNULL_END
