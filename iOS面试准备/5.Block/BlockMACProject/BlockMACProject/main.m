//
//  main.m
//  BlockMACProject
//
//  Created by 蔡浩铭 on 2019/9/18.
//  Copyright © 2019 蔡浩铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DeallocObject.h"

//16
struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};

//24
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};
// 20 + 16 + 4

struct __Block_byref_val_0 {
    void *__isa;
    struct __Block_byref_val_0 *__forwarding;
    int __flags;
    int __size;
    int val;
};

// 模仿系统__main_block_impl_0结构体
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
//    int age;
    struct __Block_byref_val_0* target;
};


//void (^block)(void);
//
//void test(){
//    int age = 10;
//
//
//
////    block =
//
//
//    // 将底层的结构体强制转化为我们自己写的结构体，通过我们自定义的结构体探寻block底层结构体
//
//
//    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)^{
//        NSLog(@"test = %d",age);
//    };
    
    /// 堆
//    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)[^{
//struct __main_block_desc_0 {
//    size_t reserved;
//    size_t Block_size;
//};
//struct __block_impl {
//    void *isa;
//    int Flags;
//    int Reserved;
//    void *FuncPtr;
//};
//// 模仿系统__main_block_impl_0结构体
//struct __main_block_impl_0 {
//    struct __block_impl impl;
//    struct __main_block_desc_0* Desc;
//    int age;
//};
//
//
//void (^block)(void);
//
//void test(){
//    int age = 10;
//
//
//
////    block =
//
//
//    // 将底层的结构体强制转化为我们自己写的结构体，通过我们自定义的结构体探寻block底层结构体
//
//
//    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)^{
//        NSLog(@"test = %d",age);
//    };
//
//    /// 堆
////    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)[^{
////        NSLog(@"test = %d",age);
////    } copy];
//
//    block = (void (^) (void))blockStruct;
//
//
//
//
//
////    [blockStruct release];
//
//    block();
//
//
//    NSLog(@"block class - %@",[block class]);
//
//
//    NSLog(@"age address = %p",&age);
//
//    NSLog(@"block address = %p",block);
//    NSLog(@"block isa = %p",blockStruct->impl.isa);
//
////    [block release];
//}
//
//int main(int argc, char * argv[]) {
//	@autoreleasepool {
//
//
//        test();
//        block();
//
//        NSLog(@"block -- %p",&block);
//
//        // 将底层的结构体强制转化为我们自己写的结构体，通过我们自定义的结构体探寻block底层结构体
//        struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)block;
//
//        NSLog(@"block address = %p",block);
//        NSLog(@"block isa = %p",blockStruct->impl.isa);
//
//        NSLog(@"block class - %@",[block class]);
//
//
//        /*
//         不使用copy block,block的类型为NSStackBlock的情况
//         1.在函数体内的 block的isa指针，指向的是栈创建的`__NSStackBlock__`结构（地址会在当前位置之上上上），可以打印block isa地址大小查看
//         2.当出了函数体的范围后，block的isa指针，指向的是block起始地址加偏移量，因此会有越界或者访问无效内容的问题。
//         */
//
//        /*
//         使用copy block，block 的类型为NSMallocBlock的情况
//         1.函数体内的block的isa指针，指向堆中创建的`NSMallocBlock__`结构，并且由于调用了copy方法，约等于增加了引用计数，
//         因此出了函数范围后，这个堆中的block结构不会被使用，在函数体内外打印的block isa地址一致
//
//
//
//         */
//
//
//	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//	}
//}

typedef void (^Block)(void);


int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        
//        NSObject *obj = [NSObject new];
//
//        NSLog(@"obj = %p",obj);
//
//        NSLog(@"class = %p", [NSObject class]);
//
//        NSLog(@"alloc = %p", [[NSObject alloc] init]);
//
//
//        int a = 10;
//        Block myBlock = ^{
//            NSLog(@"asdf%d",a);
//        };
//
//        NSLog(@"%@block = %p",[myBlock class],myBlock);
        
        __block int target = 2;
        
        NSLog(@"target = %p",&target);
        Block myBlock = ^{
            NSLog(@"myblock = %d",target);
        };
        struct __main_block_impl_0 *impl = (__bridge struct __main_block_impl_0 *)myBlock;
        NSLog(@"target = %p",&target);
        NSLog(@"myblock = %p",&myBlock);
        NSLog(@"__main_block_impl_0 = %p",&impl);
        
        
        __block NSObject *obj = [NSObject]
        
        
        
    }
}
