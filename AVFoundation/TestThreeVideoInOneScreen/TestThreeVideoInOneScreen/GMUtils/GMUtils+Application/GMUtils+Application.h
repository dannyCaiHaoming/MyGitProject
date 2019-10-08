//
//  GMUtils+Application.h
//  GemoModules
//
//  Created by Bias.Xie on 15/12/23.
//  Copyright © 2015年 Gemo. All rights reserved.
//

#import "GMUtils.h"

typedef NS_ENUM(NSInteger,DeviceType) {
    
    Unknown = 0,
    Simulator,
    IPhone_1G,          //基本不用
    IPhone_3G,          //基本不用
    IPhone_3GS,         //基本不用
    IPhone_4,           //基本不用
    IPhone_4s,          //基本不用
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X,
};


///获取应用信息工具类
@interface GMUtils (Application)

/// 获取项目名称
+ (NSString *)executableFileName;
/// app build版本号
+ (NSString *)buildVersion;
/// app版本
+ (NSString *)version;
/// app名称号
+ (NSString *)displayName;
///获得设备型号
+ (NSString *)currentDeviceVersion;

+ (NSString *)system_machine;

///设备类型
+ (DeviceType)deviceType;;

@end
