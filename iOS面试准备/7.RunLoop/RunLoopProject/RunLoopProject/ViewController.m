//
//  ViewController.m
//  RunLoopProject
//
//  Created by Danny on 2019/9/25.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "ViewController.h"
#import "LongLifeThread.h"

@interface ViewController ()<UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    /*
     主线程的runloop原来有UITrackingRunLoopMode和kCFRunLoopDefaultMode
     kCFRunLoopDefaultMode下可以正常使用timer
     但是如果scrollview滑动的时候   mode会进行切换
     方法1：将timer添加到当前runloop的commonmodes中，然后会自动添加到_commonModeItems中，当前runloop所有的mode都能使用
     方法1就是将timer作为item添加到touchAction
    
     */
    __weak ViewController *ws = self;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        ws.label.text = [NSString stringWithFormat:@"%@",[NSDate date]];
//        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//        NSLog(@"runloop.currentMode = %@",runloop.currentMode);
//    }];
//
//    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    NSLog(@"runloop.currentMode = %@",runloop.currentMode);
//    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    /*
     方法2：使用辅助线程去完成timer的动作
     */
    
    
    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.label.text = [NSString stringWithFormat:@"%@",[NSDate date]];
        });
        
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        NSLog(@"runloop.currentMode = %@",runloop.currentMode);
    }];
    
    LongLifeThread *thead = [[LongLifeThread alloc] initWithTarget:self selector:@selector(theadAddTimer) object:nil];
    
    [thead start];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    NSLog(@"runloop.currentMode = %@",runloop.currentMode);
//    [runloop addTimer:self.timer forMode:runloop.currentMode];
    
}

- (void)theadAddTimer{
    @autoreleasepool {
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [runloop addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [runloop run];
    }
    
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"dealloc");
}

@end
