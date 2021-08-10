//
//  NSObject+Extension.h
//  OCProject
//
//  Created by 蔡浩铭 on 2021/5/30.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyObject: NSObject
{
    NSString *_title;
//    NSString *_testOb;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *testOb;

- (void)printTest;
- (void)doSomeThing;

@end


/*
 扩展没有限制哪里限制，只不过一般会用于.m文件，作用只是一个额外声明的作用。
 所以如果在.h文件声明，不使用私有性，那么应该是为了将内容分开，增加易读性。
 然后为什么系统的文件不能使用，因为我就算增加了扩展的头声明，这里只是增加了声明的内容，
 但是具体实现还需要有内部文件，即.m的实现才可以。
 */
@interface MyObject ()
- (void)printTest_Ext;

@end

NS_ASSUME_NONNULL_END
