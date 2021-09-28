//
//  KVC.h
//  OCProject
//
//  Created by Danny on 2021/9/28.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVC : NSObject
{
    // Setter访问成员变量的顺序
    int _age;
    int _isAge;
    int age;
    int isAge;
}

@property (nonatomic, assign) int propertyAge;


@end

NS_ASSUME_NONNULL_END
