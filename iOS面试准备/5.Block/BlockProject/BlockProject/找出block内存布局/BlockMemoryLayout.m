//
//  BlockMemoryLayout.m
//  BlockProject
//
//  Created by Danny on 2021/10/9.
//  Copyright © 2021 Danny. All rights reserved.
//

#import "BlockMemoryLayout.h"

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};
struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};
// 模仿系统__main_block_impl_0结构体
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    int age;
};

typedef void(^Block)(void);

@implementation BlockMemoryLayout

- (void)find {
    
///*
    //MARK: 第一步
    int before = 1;
    int test = 2;
    

     
//     before : 0x7ffeee1ebccc
//     test :  0x7ffeee1ebcc8
     
// 打印基本数据类型的地址可以知道，栈内存是向下增长的，起始地址即一个数据分配的地址值，其实是这个数据在内存中的最低地址。因此获取这个数据所占的内存，需要用上一个数据起始地址减去这个数据的起始地址。
    
    NSLog(@"before = %p, test = %p",&before,&test);
    
//*/
    
  
//    int start = 0;
//
//    Block myblock = ^{
//        NSLog(@"Print my block");
//    };
//
//    NSLog(@"start = %p",&start);
//
//    NSLog(@"myBlock = %p",&myblock);
    
}

@end
