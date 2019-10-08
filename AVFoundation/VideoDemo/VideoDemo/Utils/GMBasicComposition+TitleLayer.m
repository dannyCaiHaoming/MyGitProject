//
//  GMBasicComposition+TitleLayer.m
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/20.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "GMBasicComposition+TitleLayer.h"
#import <objc/runtime.h>

static id GMTitleLayerKey;
@implementation GMBasicComposition (TitleLayer)

- (void)setTitleLayer:(CALayer *)titleLayer{
    objc_setAssociatedObject(self, &GMTitleLayerKey, titleLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)titleLayer{
    return objc_getAssociatedObject(self, &GMTitleLayerKey);
}

@end
