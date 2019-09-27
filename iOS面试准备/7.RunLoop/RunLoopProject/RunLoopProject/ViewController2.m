//
//  ViewController2.m
//  RunLoopProject
//
//  Created by Danny on 2019/9/25.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "ViewController2.h"
#import "LongLifeThread.h"

@interface ViewController2 ()
{
    LongLifeThread *thead;
}

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    
    NSLog(@"main --  %@ ---  %@",runloop,[NSThread currentThread]);
    
    thead = [[LongLifeThread alloc] initWithTarget:self selector:@selector(theadAction) object:nil];
    
    [thead start];
    
    
    
//    [self performSelector:@selector(theadAction) onThread:thead withObject:nil waitUntilDone:NO];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
     [self performSelector:@selector(touchAction) onThread:thead withObject:nil waitUntilDone:NO];
    
}

- (void)theadAction{
    
    /*
     线程常驻：
     在线程初始化的时候，获取该runloop，添加item(这里用了NSPort)，使得runloop可以保持执行，并且设置runloop运行状态
     
     */
    
    @autoreleasepool {
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        
        NSLog(@"%@---%@",runloop,[NSThread currentThread]);
        
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        
        [runloop run];
    }
    

}

- (void)touchAction{
    NSLog(@"%@ --- touchAction",[NSThread currentThread]);
}



@end
