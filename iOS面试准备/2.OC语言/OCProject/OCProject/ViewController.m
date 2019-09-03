//
//  ViewController.m
//  OCProject
//
//  Created by 蔡浩铭 on 2019/9/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController.h"
#import "People.h"


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
	
	[self.people addObserver:self forKeyPath:@"money" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew  context:nil];
	
//	self.people.year = 3;
	[self.people setValue:@999 forKey:@"year"];
	self.people.work = @"iOS";
	

	NSLog(@"%@---",self.people);

}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//	if ([keyPath  isEqual: @"money"]) {
//		NSLog(@"%@",object);
//	}
//}


@end
