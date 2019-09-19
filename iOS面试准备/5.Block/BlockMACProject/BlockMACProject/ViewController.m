//
//  ViewController.m
//  BlockMACProject
//
//  Created by 蔡浩铭 on 2019/9/18.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	
	Person *person = [[Person alloc] init];

	person.initBlock;
//
	person.executeBlock;

	[person release];
	
}

- (void)dealloc {
	[super dealloc];
	NSLog(@"ViewController dealloc");
	
	
}


@end
