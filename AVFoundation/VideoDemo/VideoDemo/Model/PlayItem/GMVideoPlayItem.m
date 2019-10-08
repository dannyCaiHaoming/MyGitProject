//
//  GMVideoPlayItem.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMVideoPlayItem.h"

@implementation GMVideoPlayItem

- (PlayItemType)type{
    return kPlayItem_Video;
}


- (CMTime)durationTime{
    return CMTimeMakeWithSeconds(3, NSEC_PER_SEC);
}


@end
