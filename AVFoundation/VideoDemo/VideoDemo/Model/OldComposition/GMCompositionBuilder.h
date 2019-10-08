//
//  GMCompositionBuilder.h
//  VideoDemo
//
//  Created by 蔡浩铭 on 2019/2/1.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMComposition.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GMCompositionBuilder <NSObject>

- (id <GMComposition>)buildComposition;

@end

NS_ASSUME_NONNULL_END
