//
//  GMBasicComposition.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/1/31.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMComposition.h"

///对系统AVComposition进行封装的基本类

NS_ASSUME_NONNULL_BEGIN

@interface GMBasicComposition : NSObject<GMComposition>


@property (strong, readonly, nonatomic) AVComposition *composition;

+ (instancetype)compositionWithComposition:(AVComposition *)composition;
- (instancetype)initWithComposition:(AVComposition *)composition;


@end

NS_ASSUME_NONNULL_END
