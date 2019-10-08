//
//  GMAddPlayItem.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMAddPlayItem.h"

@implementation GMAddPlayItem

- (PlayItemType)type{
    return kPlayItem_Add;
}

+ (instancetype)initialAddPlayItem{
    GMAddPlayItem *item = [GMAddPlayItem new];
    return item;
}

@end
