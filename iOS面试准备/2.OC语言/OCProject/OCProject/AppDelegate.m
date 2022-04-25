//
//  AppDelegate.m
//  OCProject
//
//  Created by 蔡浩铭 on 2019/9/3.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import "AppDelegate.h"

@interface MyString : NSString

@end

@implementation MyString

- (void)dealloc {
    NSLog(@"%lu dealloc",(unsigned long)self.length);
}

+ (instancetype)stringWithString:(NSString *)string {
    return [MyString stringWithString:string];
//    return [super stringWithString:string];
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
    
    
    [MyString new];
    MyString *s1 = [MyString new];
    s1 = @"1";
    do {
        MyString *s2 = [MyString new];
        s2 = @"22";
    } while (nil);
    
    __weak MyString *s3 = [MyString new];
    s3 = @"333";

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
