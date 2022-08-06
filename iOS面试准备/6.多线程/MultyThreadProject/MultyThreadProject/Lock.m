//
//  Lock.m
//  MultyThreadProject
//
//  Created by 蔡浩铭 on 2022/5/3.
//  Copyright © 2022 蔡浩铭. All rights reserved.
//

#import "Lock.h"

@interface Lock()

@property (strong, nonatomic) NSCondition* condition;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation Lock

- (instancetype)init {
    if (self = [super init]) {
        self.condition = [[NSCondition alloc] init];
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)add {
    
    [self.condition lock];
    
    [self.data addObject:@"1"];
    
    
    
    [self.condition signal];
    
    NSLog(@"add  signal -- %@",[NSThread currentThread]);
    
    
    sleep(1);
    
    [self.condition unlock];
    
//    printf("add");
    NSLog(@"add -- %@",[NSThread currentThread]);
}

- (void)remove {
    [self.condition lock];
    
    if (self.data.count <= 0) {
        [self.condition wait];
    }
    
    NSLog(@"remove  wait -- %@",[NSThread currentThread]);
    
    [self.condition unlock];
    
//    printf("remove");
    NSLog(@"remove -- %@",[NSThread currentThread]);
}

@end
