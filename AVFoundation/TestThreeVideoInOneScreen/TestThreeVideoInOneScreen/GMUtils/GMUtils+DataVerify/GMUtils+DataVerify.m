//
//  GMUtils+DataVerify.m
//  Gemo.com
//
//  Created by Horace.Yuan on 15/10/16.
//  Copyright © 2015年 gemo. All rights reserved.
//

#import "GMUtils+DataVerify.h"

@implementation GMUtils (DataVerify)


//+ (NSString *)md5FormString:(NSString *)str digestLength:(NSInteger)digestLength
//    const char *cStr =
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, self.length, digest );
//    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [result appendFormat:@"%02x", digest[i]];
//    return result;
//}

+ (BOOL)validateMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,175,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|7[8]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,179,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[6]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,170,180,189
     22         */
    NSString * CT = @"^1((33|53|7[7]|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    return ([regextestmobile evaluateWithObject:mobileNum] || [regextestcm evaluateWithObject:mobileNum] ||
            [regextestct evaluateWithObject:mobileNum]  || [regextestcu evaluateWithObject:mobileNum]);
}


// 身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    //NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSString *regex2 = @"(\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z])";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    return flag;
}


@end
