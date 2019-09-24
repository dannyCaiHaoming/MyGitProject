//
//  UserCenter.h
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2019/9/24.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserCenter : NSObject

{
	dispatch_queue_t queue;
	NSMutableDictionary *dictionary;
}


- (id)objectForKey:(NSString *)key;

- (void)setValue:(id)value forKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
