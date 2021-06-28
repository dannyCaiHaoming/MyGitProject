//
//  Person.h
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TestBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (copy) TestBlock testBlock;



- (void)initBlock;
- (void)executeBlock;


@end

NS_ASSUME_NONNULL_END
