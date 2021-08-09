//
//  Person.m
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "Person.h"


@interface Person ()

@property (nonatomic, weak) void (^block) (void);

@property (nonatomic, weak) NSObject *obj;

@end

static int value = 3;
static int value1 = 6;
static Person *person;
@implementation Person

+ (instancetype) share {
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        if (person == nil) {
            person = [[Person alloc] init];
        }
    });
    return person;
}

- (void)initBlock {
	
	
//	NSLog(@"%p",self);
//
//
//	__block Person *blockSelf = self;
//
//	self.testBlock = ^{
//
//		NSLog(@"%p",blockSelf);
//
//
//	} ;
	
//    int a = 5;
//    void (^b) (void) = ^{
//        NSLog(@"print --- ");
//    };
//
//    NSLog(@"initBlock --- %@",b);
//
//    self.block = b;
//
//
//    NSObject *o = [NSObject new];
//    self.obj = o;
//
    
    
    NSString *str = @"123";
    char *ch = "b =\n";

    int * a = &value;
    void (^block)(void) = ^{
//        printf(@" char -- %s \n",*ch); // b =
//        printf("int -- %@\n",a);
        NSLog(@"int = %d\n",*a);
        NSLog(@"char = %c",*ch);
        NSLog(@"str = %@",str);
    };
    NSLog(@"block -- %@\n",block);
    char *n = "value had changed.b =\n";
    ch = n;
    *a = value1;
    str = @"345";
    
    block();
}


- (void)executeBlock{
//	self.testBlock();
//    NSLog(@"obj -- %@",self.obj);
//    self.block();
//    NSLog(@"executeBlock ----  %@",self.block);
}

- (void)dealloc{
	NSLog(@"Person dealloc");
}

@end
