//
//  GMVideoPlayItem.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicPlayItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMVideoPlayItem : GMBasicPlayItem

//存储视频数组
@property (nonatomic, strong) NSArray <AVAsset *>*videoArray;

@end

NS_ASSUME_NONNULL_END
