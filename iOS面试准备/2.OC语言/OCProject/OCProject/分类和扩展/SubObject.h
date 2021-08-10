//
//  SubObject.h
//  OCProject
//
//  Created by 蔡浩铭 on 2021/6/1.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "MyObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubObject : MyObject

@end


/*
 extension的成员变量声明是私有的，属性可以公开
 */
@interface SubObject ()
{
    BOOL test;
    BOOL otherTest;
}
@property (readwrite,assign) BOOL mytest;
@end

NS_ASSUME_NONNULL_END
