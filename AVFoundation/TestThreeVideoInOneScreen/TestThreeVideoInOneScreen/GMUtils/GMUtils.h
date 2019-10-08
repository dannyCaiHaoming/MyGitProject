//
//  GMUtils.h
//  Gemo.com
//
//  Created by Horace.Yuan on 15/9/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GMUtils : NSObject

///返回版本号信息
+ (NSString *)version;
+ (void)printUmengLogWithMessage:(NSString *)message;

@end
