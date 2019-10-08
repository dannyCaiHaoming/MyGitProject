//
//  GMBasicCollectionViewCell.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicCollectionViewCell.h"

@implementation GMBasicCollectionViewCell

+ (NSString *)identify{
    return NSStringFromClass([self class]);
}

+ (UINib *)nib{
    return [UINib nibWithNibName: NSStringFromClass([self class]) bundle:nil];
}


@end
