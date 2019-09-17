//
//  ViewController.m
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "ViewController.h"

typedef void(^TestBlock)(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __block ViewController *blockSelf = self;
    
    TestBlock block = ^{
        NSLog(@"%@",blockSelf);
    };

    
    block();
}

//- (void)dealloc{
//    NSLog(@"dealloc");
//}


//- (void)test {
//
//}

@end
