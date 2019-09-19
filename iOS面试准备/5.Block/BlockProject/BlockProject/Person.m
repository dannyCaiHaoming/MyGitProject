//
//  Person.m
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "Person.h"



@implementation Person

- (void)initBlock {
	
	
	NSLog(@"%p",self);

	
	__block Person *blockSelf = self;
	
	self.testBlock = ^{

		NSLog(@"%p",blockSelf);
		
		
	} ;
	
	
	
	
	
	
}


- (void)executeBlock{
	self.testBlock();
}

- (void)dealloc{
	NSLog(@"Person dealloc");
}

@end
