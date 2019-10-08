//
//  GMUtils+DataVerify.h
//  Gemo.com
//
//  Created by Horace.Yuan on 15/10/16.
//  Copyright © 2015年 gemo. All rights reserved.
//

#import "GMUtils.h"

///数据检验工具
@interface GMUtils (DataVerify)

/**
 验证电话号码是否合法
 @param     mobileNum   NSString    用于判断的电话号码
 @return    BOOL
 */
+ (BOOL)validateMobileNumber:(NSString *)mobileNum;

/**
 验证身份证是否合法
 @param     identityCard    NSString    身份证卡
 @return    BOOL    
 */
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

@end
