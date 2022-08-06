//
//  Lock.h
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2022/5/3.
//  Copyright © 2022 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Lock : NSObject

- (void)add;
- (void)remove;

@end

NS_ASSUME_NONNULL_END
