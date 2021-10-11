//
//  BlockMemoryLayout.m
//  BlockProject
//
//  Created by Danny on 2021/10/9.
//  Copyright © 2021 Danny. All rights reserved.
//

#import "BlockMemoryLayout.h"
#import "Person.h"

// 16
struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};

// 24
struct __block_impl {
    void *isa; //8
    int Flags; //4
    int Reserved;//4
    void *FuncPtr;//8
};

struct __Block_byref_val_0 {
    void *__isa;
    struct __Block_byref_val_0 *__forwarding;
    int __flags;
    int __size;
    int val;
};

// 模仿系统__main_block_impl_0结构体
struct __main_block_impl_0 {
    //24
    struct __block_impl impl;
    // 8
    struct __main_block_desc_0* Desc;
//    struct __Block_byref_val_0* target;
    int target;
};

typedef void(^Block)(void);

@implementation BlockMemoryLayout

- (void)find {
    
/*
    //MARK: 第一步
    int before = 1;
    int test = 2;

//     before : 0x7ffeee1ebccc
//     test :  0x7ffeee1ebcc8
// 打印基本数据类型的地址可以知道，栈内存是向下增长的，起始地址即一个数据分配的地址值，其实是这个数据在内存中的最低地址。因此获取这个数据所占的内存，需要用上一个数据起始地址减去这个数据的起始地址。
    
    NSLog(@"before = %p, test = %p",&before,&test);
    
*/
    
    
/*
    //MARK: 第二步
    
    int target = 2;
    NSLog(@"start = %p",&target);
    Block myblock = ^{
        NSLog(@"Print my block %d",target);
    };
    
    struct __main_block_impl_0 *impl = (__bridge struct __main_block_impl_0 *)myblock;
    // start : 0x7ffee269cabc
    // myblock: 0x7ffee269cab0
    NSLog(@"target = %p",&target);
    NSLog(@"myBlock = %p",&myblock);
 NSLog(@"__main_block_impl_0 = %p",&impl);
    //  通过内存地址查看，能看到block指针的首地址和int数据的首地址差了12个字节，打印block指针实际用到的字节是8.那剩余的4个字节，为为了内存对齐。
    // block 实际也是一个结构体指针。从强转回底层block代码实现的过程中可以发现。因此打印block的地址，只能看到指向block结构体的指针。
    
*/
    
    
    
    //MARK: 第三步
    int target = 2;
    NSLog(@"start = %p",&target);
    //typedef void(^Block)(void);
    void (^myblock) (void) = ^{
        NSLog(@"Print my block %d",target);
    };
    
    void (^myblock2) (void) = ^{
        NSLog(@"Print 2 my block %d",target);
    };
    
    void (^myblock3) (void) = ^{
        NSLog(@"Print 3 my block %d",target);
    };
    
    struct __main_block_impl_0 *impl = (__bridge struct __main_block_impl_0 *)myblock;
    // start : 0x7ffee269cabc
    // myblock: 0x7ffee269cab0
    NSLog(@"target = %p",&target);
    NSLog(@"myBlock = %p",&myblock);
    NSLog(@"myBlock2 = %p",&myblock2);
    NSLog(@"myBlock3 = %p",&myblock3);
    NSLog(@"__main_block_impl_0 = %p",&impl);
     
     
    
    //MARK: 第四步
    
    
//    Block myblock;
//
//    {
//        Person *p = [Person new];
//        myblock  = ^{
//            NSLog(@"Print my block %@",p);
//        };
//
//    }
    
    
}

@end
