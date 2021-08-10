//
//  NSObject+NSObject_Category.h
//  OCProject
//
//  Created by 蔡浩铭 on 2021/5/30.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (NSObject_Category)

@property (assign, nonatomic) BOOL isTest;

@end


@interface NSObject ()

{
    BOOL test;
}

@end

NS_ASSUME_NONNULL_END
