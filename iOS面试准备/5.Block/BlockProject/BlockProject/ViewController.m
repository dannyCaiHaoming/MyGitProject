//
//  ViewController.m
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"



typedef void(^TestBlock)(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
	Person *person = [[Person alloc] init];
	
	person.initBlock;
	//
	person.testBlock();
}

- (void)dealloc{
    NSLog(@"ViewController dealloc");
}


//- (void)test {
//
//}

@end
