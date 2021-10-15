//
//  SuperKeyword.h
//  RuntimeProject
//
//  Created by 蔡浩铭 on 2021/10/15.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperKeywordFather : NSObject

- (void)log;

@end

@implementation SuperKeywordFather

- (void)log {
    NSLog(@"%s",__func__);
}

@end

@interface SuperKeyword : SuperKeywordFather

@end

NS_ASSUME_NONNULL_END
