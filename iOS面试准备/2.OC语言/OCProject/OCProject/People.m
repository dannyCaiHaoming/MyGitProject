//
//  People.m
//  OCProject
//
//  Created by 蔡浩铭 on 2019/9/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "People.h"

@implementation People


//- (NSString *)money {
//
//	return [NSString stringWithFormat:@"%d_%@",_year,_work];
//}
//
//
//+ (NSSet<NSString *> *)keyPathsForValuesAffectingMoney{
//	NSSet <NSString *> *set = [NSSet setWithObjects:@"year",@"work", nil];
//	return set;
//}

- (instancetype)init{
	if (self = [super init]){
//		self->_year = 1;
//		self->_isYear = 2;
//		self->year = 3;
//		self->isYear = 4;
	}
	return self;
}


- (void)log {
    NSLog(@"log");
}

//MARK:First Step
//- (void)setYear:(int)year{
//	NSLog(@"setYear");
//	self->year = year;
//}
//
//
////MARK:Second Step
//- (void)_setYear:(int)year{
//	NSLog(@"_setYear");
//	self->year = year;
//}

//MARK:Third Step
+ (BOOL)accessInstanceVariablesDirectly{
	NSLog(@"accessInstanceVariablesDirectly");
	return YES;
}

@end
