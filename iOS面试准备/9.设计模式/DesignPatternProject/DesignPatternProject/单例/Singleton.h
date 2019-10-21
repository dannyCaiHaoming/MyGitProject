//
//  Singleton.h
//  DesignPatternProject
//
//  Created by 蔡浩铭 on 2019/10/21.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject<NSCopying>

- (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
