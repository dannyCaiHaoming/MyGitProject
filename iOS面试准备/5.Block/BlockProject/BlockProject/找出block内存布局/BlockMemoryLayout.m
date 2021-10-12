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
    void *__isa; //8
    struct __Block_byref_val_0 *__forwarding; //8
    int __flags; // 4
    int __size; // 4
    int val; // 4
};

// 模仿系统__main_block_impl_0结构体
struct __main_block_impl_0 {
    //24
    struct __block_impl impl;
    // 8
    struct __main_block_desc_0* Desc;
    // 8
    struct __Block_byref_val_0* target;
//    int target;
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
    
    
/*
    //MARK: 第三步
    
    
    
    __block int target = 2;
    NSLog(@"target = %p",&target);
    //typedef void(^Block)(void);
    void (^myblock) (void) = ^{
        NSLog(@"Print my block %d",target);
    };
    
    void (^myblock2) (void) = ^{
        NSLog(@"Print 2 my block %d",target);
    };
    
    struct __main_block_impl_0 *impl = (__bridge struct __main_block_impl_0 *)myblock;
    // start : 0x7ffee269cabc
    // myblock: 0x7ffee269cab0
    NSLog(@"target = %p",&target);
    NSLog(@"myBlock = %p",&myblock);
    NSLog(@"myBlock2 = %p",&myblock2);
    NSLog(@"__main_block_impl_0 = %p",&impl);
    
    
      //BlockProject[31451:1229642] target = 0x7ffee4bafab8
      //BlockProject[31451:1229642] target = 0x6000035b90f8
      //BlockProject[31451:1229642] myBlock = 0x7ffee4bafa88
      //BlockProject[31451:1229642] myBlock2 = 0x7ffee4bafa58
      //BlockProject[31451:1229642] __main_block_impl_0 = 0x7ffee4bafa28
     
     // __block_by_ref结构的地址是 0x7ffee4bafaa0
     // 会存储在target变量
     

    */
    
    
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
    
    
    //MARK: 第七步
    
    int val = 3;
    
    int test = 5;
//    {
        NSLog(@"val = %p",&val);
        Block myblock = ^{
            NSLog(@"%d",val);
        };

        NSLog(@"val = %p",&val);
        NSLog(@"myblock = %p",&myblock);

        
        struct __main_block_impl_0 *impl = (__bridge struct __main_block_impl_0*)myblock;
        myblock = nil;
//    }
    NSLog(@"val = %p",&val);
    
//    Block myblock2 = ^{
//        NSLog(@"%d",val);
//    };
//    NSLog(@"val = %p",&val);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"asdfsd");
    });
}

@end
