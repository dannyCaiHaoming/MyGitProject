//
//  ViewController.m
//  MemoryProject
//
//  Created by Danny on 2019/9/16.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+NSTimer_BreakLoop.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSMutableArray *a = [NSMutableArray arrayWithObject:@"123"];
//
//    self.array = [a mutableCopy];
//
//    [self.array addObject:@"234"];
    
//    self.timer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
	
	self.timer = [NSTimer chm_scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) repeat:YES];
}

- (void)timerAction{
    NSLog(@"%@",[NSDate date]);
    
//    [self.timer invalidate];
//    self.timer = nil;
}

- (void)dealloc{
    NSLog(@"dealloc");
}


@end
