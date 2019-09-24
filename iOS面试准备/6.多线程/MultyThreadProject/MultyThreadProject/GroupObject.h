//
//  GroupObject.h
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2019/9/24.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupObject : NSObject

{
	dispatch_group_t group;
	dispatch_queue_t queue;
	NSArray *array;
}


- (void)useGroup;


@end

NS_ASSUME_NONNULL_END
