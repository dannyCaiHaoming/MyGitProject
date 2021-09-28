//
//  main.m
//  OCProject
//
//  Created by 蔡浩铭 on 2019/9/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>


int main(int argc, char * argv[]) {
	@autoreleasepool {
        

//        NSLog(@"%lu",sizeof(uint));
        
        
//        NSObject *obj = [[NSObject alloc] init];
//        NSLog(@"NSObject instance size = %zu",class_getInstanceSize([NSObject class]));
        
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
