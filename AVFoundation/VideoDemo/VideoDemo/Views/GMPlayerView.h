//
//  GMPlayerView.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;
NS_ASSUME_NONNULL_BEGIN

@interface GMPlayerView : UIView

@property (nonatomic, weak) AVPlayer *player;

@end

NS_ASSUME_NONNULL_END
