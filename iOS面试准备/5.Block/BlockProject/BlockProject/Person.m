//
//  Person.m
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "Person.h"



@implementation Person


- (void)test{
    
    
    
    self.testBlock = ^{
        NSLog(@"%@",self);
    };
    
    
    self.testBlock();
}

@end
