//
//  Person.h
//  BlockMACProject
//
//  Created by 蔡浩铭 on 2019/9/18.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TestBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (assign) TestBlock testBlock;


@property (retain) NSObject *obj1;




- (void)initBlock;
- (void)executeBlock;


@end

NS_ASSUME_NONNULL_END
