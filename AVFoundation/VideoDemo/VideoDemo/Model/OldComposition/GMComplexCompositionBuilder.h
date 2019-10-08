//
//  GMComplexCompositionBuilder.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/14.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMCompositionBuilder.h"
#import "GMBasicPlayItem.h"
#import "GMVideoPlayItem.h"
#import "GMBasicComposition.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMComplexCompositionBuilder : NSObject<GMCompositionBuilder>

- (id)initWithPlayItems:(NSArray <GMBasicPlayItem *> *)playItems;


@end

NS_ASSUME_NONNULL_END
