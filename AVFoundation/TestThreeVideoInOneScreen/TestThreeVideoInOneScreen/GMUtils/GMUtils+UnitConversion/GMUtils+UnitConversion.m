//
//  GMUtils+UnitConversion.m
//  GLDVRModule
//
//  Created by 蔡浩铭 on 2018/11/13.
//  Copyright © 2018 BBias Xie. All rights reserved.
//

#import "GMUtils+UnitConversion.h"

static const float SystemScale = 1024.0;

@implementation GMUtils (UnitConversion)

+ (long)mbUnitConversionFromKb:(long)kb{
    return kb / SystemScale;
}


@end
