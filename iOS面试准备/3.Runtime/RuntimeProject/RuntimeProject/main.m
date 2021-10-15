//
//  main.m
//  RuntimeProject
//
//  Created by 蔡浩铭 on 2019/10/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Objc-MsgSend.h"
#import "KindAndMember.h"
#import "RuntimeAPI.h"

int main(int argc, char * argv[]) {
	NSString * appDelegateClassName;
	@autoreleasepool {
	    // Setup code that might create autoreleased objects goes here.
        
//        [[Objc_MsgSend new] test];
//        [Objc_MsgSend test];
//
//
//        [[KindAndMember new] doSomeThings];
        
        
        [[RuntimeAPI new] test1];
        
//	    appDelegateClassName = NSStringFromClass([AppDelegate class]);

	}
	return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
