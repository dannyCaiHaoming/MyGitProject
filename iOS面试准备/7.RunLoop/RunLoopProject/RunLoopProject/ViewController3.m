//
//  ViewController3.m
//  RunLoopProject
//
//  Created by 蔡浩铭 on 2021/9/8.
//  Copyright © 2021 Danny. All rights reserved.
//

#import "ViewController3.h"
#import "CheckStuck.h"

@interface ViewController3 ()

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CheckStuck *test = [CheckStuck new];
    [test beginMonitor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
}

@end
