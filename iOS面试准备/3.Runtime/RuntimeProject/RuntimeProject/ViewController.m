//
//  ViewController.m
//  RuntimeProject
//
//  Created by 蔡浩铭 on 2019/10/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Student.h"
#import "StackHeap.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
//    Person *p = [[Person alloc] init];
//
//    [p performSelector:@selector(helloworld)];

    
//    Student *s = [[Student alloc] init];
    
    [self stackHeap];
}


- (void)stackHeap {
    [[StackHeap new] test];
}
@end
