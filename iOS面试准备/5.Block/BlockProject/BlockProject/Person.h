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

@property (nonatomic, strong) id hold;
@property (nonatomic, copy) void(^holdBlock)(void);
@property (nonatomic, strong) NSMutableArray *objs;
@property (nonatomic, strong) NSMutableDictionary *dicts;

- (void)initBlock;
- (void)executeBlock;


+ (instancetype) share;


@end

NS_ASSUME_NONNULL_END
