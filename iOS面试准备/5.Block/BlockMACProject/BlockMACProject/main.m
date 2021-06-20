//
//  main.m
//  BlockMACProject
//
//  Created by 蔡浩铭 on 2019/9/18.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


void (^block)(void);

void test(){
    int age = 10;
    block = ^{
        NSLog(@"test = %d",age);
    };
    
    NSLog(@"block class - %@",[block class]);
    
    
    NSLog(@"age address = %p",&age);
    
    NSLog(@"block address = %p",block);
    
//    [block release];
}

int main(int argc, char * argv[]) {
	@autoreleasepool {
        
        
        test();
    
        NSLog(@"block -- %p",&block);
//        NSLog(@"block class - %@",[block class]);
        
        
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
