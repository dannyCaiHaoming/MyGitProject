//
//  ViewController.m
//  OCProject
//
//  Created by 蔡浩铭 on 2019/9/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
//#import "NSObject_Category.h"
#import "MyObject.h"
#import "MyObject+Category1.h"
#import "MyObject+Category2.h"
#import "Keyword.h"

@interface ViewController ()

@property (nonatomic, strong) People *people;

@end

@implementation ViewController

- (People *)people{
	if (_people == nil) {
		_people = [[People alloc] init];

	}
	return _people;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
//	[self.people addObserver:self forKeyPath:@"money" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew  context:nil];
//
////	self.people.year = 3;
//	[self.people setValue:@999 forKey:@"year"];
//	self.people.work = @"iOS";
//
//
//	NSLog(@"%@---",self.people);
	
//	[self testCopy];
//    [self test_Category];
//    [self test_Extension];

    [self testKeyword];
}

- (void)testCopy{
	
	NSArray *arr1 = [NSArray arrayWithObject:@"arr1"];
	NSMutableArray *mArr1 = [NSMutableArray arrayWithObject:@"mArr1"];
	
	
	NSLog(@"inArray copy---%@",[[arr1 copy] class]);
	NSLog(@"inArray mutableCopy---%@",[[arr1 mutableCopy] class]);
	
	NSLog(@"mArray copy---%@",[[mArr1 copy] class]);
	NSLog(@"mArray mutableCopy---%@",[[mArr1 mutableCopy] class]);
//	NSLog(@"arr1 = %@",[self.arr1 class]);
//	NSLog(@"arr2 = %@",[self.arr2 class]);
//	self.arr1 = arr1;
//	self.arr2 = arr1;
//
//
//
//	NSLog(@"arr1 = %@",[self.arr1 class]);
//	NSLog(@"arr2 = %@",[self.arr2 class]);
//	self.arr1 = mArr1;
//	self.arr2 = mArr1;
//
//	[mArr1 addObject:@"add"];
//
//	NSLog(@"mArr1 = %@",[self.mArr1 class]);
//	NSLog(@"mArr2 = %@",[self.mArr2 class]);
//	self.mArr1 = arr1 ;
//	self.mArr2 = arr1 ;
//
//
//
//	NSLog(@"mArr1 = %@",[self.mArr1 class]);
//	NSLog(@"mArr2 = %@",[self.mArr2 class]);
//	self.mArr1 = [mArr1 copy];
//	self.mArr2 = [mArr1 copy];;
//	NSLog(@"mArr1 = %@",[self.mArr1 class]);
//	NSLog(@"mArr2 = %@",[self.mArr2 class]);
	
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//	if ([keyPath  isEqual: @"money"]) {
//		NSLog(@"%@",object);
//	}
//}


- (void)test_Category {
    NSObject *t = [[NSObject alloc] init];
//    t.isTest = true;
//    NSLog(@"%d",t.isTest);

}


- (void)test_Extension {
    MyObject *object = [[MyObject alloc] init];
//    [object doSomeThing];
}

- (void)testKeyword {
    Keyword *k = [[Keyword alloc] init];
    [k keyword];
}

@end
