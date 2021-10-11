//
//  main.m
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/runtime.h>

typedef void(^Block)(void);

static int NotInitInt;
static int initInt = 10;
static int initInt2 = 10;
Block NotInitGlobalBlock;
Block InitGlocalBlock = ^{
    printf("i m InitGlocalBlock");
};
static Block StaticBlock;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
//        int intVarInStack = 1;
//        printf("&intVarInStack:%p, intVarInStack:%d \n", &intVarInStack, intVarInStack);
//
//        __block int val = 0;
//
//        printf("&b:%p, b:%d \n", &val, val);
//        NSArray *blockArray = [[NSArray alloc] initWithObjects:^{
//            printf("hello world!");},
//            ^{
//                printf("inBlock2    &val:%p, val:%d \n", &val, val);
//                ++val;
//            },
//        nil];
//
//
//        NSLog(@"%@",[^{
//            NSLog(@"%p",&intVarInStack);
//        } class]);
//
//        printf("&intVarInStack:%p, intVarInStack:%d \n", &intVarInStack, intVarInStack);
//        printf("&val:%p, val:%d \n", &val, val);
//        ++val;
        
//        __block char charBlock = 'a';
//        
//        
//        __block int mallocInt2 = 2;
//        int mallocInt3 = 3;
//        
//        NSLog(@"mallocInt3 == %p\n",&mallocInt3);
//        printf("char = %p\n",&charBlock);
//
//        printf("before mallocInt1 -- %p\n",&mallocInt1);
//        printf("before mallocInt2 -- %p\n",&mallocInt2);
//        printf("before mallocInt3 -- %p\n",&mallocInt3);
//        NSLog(@"stackBlock1 -- %p",[^{
//            printf("hello malloc block,int = %d",mallocInt1);
//        } copy]);
        
//        __block int mallocInt1 = 1;
//        int start = 999;
//
//        NSLog(@"target == %p\n",&start);
//
//        Block mallocBlock1 = [^{
////            printf("hello malloc block,int = %d",mallocInt1);
//        } copy];
//        printf("mallocBlock1 = %p\n",&mallocBlock1);
//
//        int end = 1000;
//        NSLog(@"target end == %p\n",&end);
//
//        printf("after mallocInt1 -- %p\n",&mallocInt1);
        

        /*
        
         加了__block之后，结构体由4字节的int变成了28字节的__block_byref_val
         1字节的char变成了15字节的__block_byref_val
        
        3个：
        112
        2个：
        88
        1个：
        24
        
        */
        
//        int mallocInt2 = 2;
////        NSLog(@"stackBlock2 -- %p",^{
////            printf("hello malloc block,int = %d",mallocInt2);
////        });
//
//        Block mallocBlock2 = [^{
//            printf("hello malloc block,int2 = %d",mallocInt2);
//        } copy];
//
//        printf("mallocBlock2 = %p\n",&mallocBlock2);
//
//        int mallocInt3 = 3;
//
//        __weak Block wsblock = ^{
//            printf("hello malloc block,int = %d",mallocInt2);
//        };
//        NSLog(@"stackBlock3 -- %p",&wsblock);
        
        
        /*
         栈block：
         12个字节
         堆block：
         
         */
        
//        Block mallocBlock3 = [^{
//            printf("hello malloc block,int3= %d",mallocInt3);
//        } copy];
        
//        // 未初始化
//        printf("未初始化的global -- %p\n",&NotInitGlobalBlock);
//        // 初始化
//        printf("初始化global -- %p\n",&InitGlocalBlock);
//
//
//        printf("StaticBlock中global -- %p\n",&StaticBlock);
//
//        printf("static not init int -- %p\n",&NotInitInt);
//
//        printf("size of block = %lu\n",sizeof(InitGlocalBlock));
//
//        printf("static init int -- %p\n",&initInt);
//
//        printf("static init int2 -- %p\n",&initInt2);
        
        
//        printf("mallocBlock -- %p,---size = %lu  --- instance size = %lu\n",&mallocBlock,sizeof(mallocBlock),class_getInstanceSize([mallocBlock class]));
        
//        printf("mallocBlock2 -- %p,---size = %lu --- instance size = %lu\n",&mallocBlock2,sizeof(mallocBlock2),class_getInstanceSize([mallocBlock2 class]));
        
//        printf("mallocInt1 = %p\n",&mallocInt1);
//        printf("mallocBlock1 = %p\n",&mallocBlock1);
//        printf("mallocInt2 = %p\n",&mallocInt2);
//        printf("mallocBlock2 = %p\n",&mallocBlock2);
//        printf("mallocInt3 = %p\n",&mallocInt3);
//        printf("mallocBlock3 = %p\n",&mallocBlock3);
        
        return 0;
    }
}
