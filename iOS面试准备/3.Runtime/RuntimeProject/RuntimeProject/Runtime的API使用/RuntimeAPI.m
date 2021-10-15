//
//  RuntimeAPI.m
//  RuntimeProject
//
//  Created by 蔡浩铭 on 2021/10/15.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "RuntimeAPI.h"
#import <objc/runtime.h>

@interface RuntimeAPI ()
{
    int age;
}
@property (assign, nonatomic) int property_age;


@end

@implementation RuntimeAPI

//The function must take at least two arguments—self and _cmd.
void run(id self,SEL _cmd) {
    NSLog(@"_____%@ - %@", self, NSStringFromSelector(_cmd));
}

//MARK: --- 动态添加类
/*
 类的成员变量不能在objc_registerClassPair后添加。objc_registerClassPair类开辟空间后，不允许在改变内存布局
 */
- (void)test {
    

    Class newClass = objc_allocateClassPair([NSObject class], "NewClass", 0);
    
    class_addIvar(newClass, "_age", 4, 1, @encode(int));
    class_addMethod(newClass, @selector(run), (IMP)run, "v@:");
        
    objc_registerClassPair(newClass);
    
    
    id objc = [[newClass alloc] init];
    
    [objc setValue:@10 forKey:@"_age"];
    [objc performSelector:@selector(run)];
    
    NSLog(@"----%@",[objc valueForKey:@"_age"]);
    
    objc = nil;
    
    //Do not call if instances of this class or a subclass exist.
    objc_disposeClassPair(newClass);
}


//MARK: --- 成员变量
- (void)test1 {
    Ivar ageIvar = class_getInstanceVariable([RuntimeAPI class], "age");
    NSLog(@"%s---%s",ivar_getName(ageIvar),ivar_getTypeEncoding(ageIvar));
    
    Ivar propertyAgeIvar = class_getInstanceVariable([RuntimeAPI class], "_property_age");
    
    RuntimeAPI *new = [RuntimeAPI new];
    //object_setIvar(id _Nullable obj, Ivar _Nonnull ivar, id _Nullable value)
    /*
     value为指针类型，(void *)
     */
    object_setIvar(new, propertyAgeIvar, (__bridge  id)(void *)10);
    NSLog(@"%d, %d",new.property_age,new->age);
    

    //
    unsigned int count;
    Ivar *ivars = class_copyIvarList([RuntimeAPI class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
    }
    
    free(ivars);
    
}


- (void)transformFromjson:(NSDictionary *)json {
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSMutableString *name = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        [name deleteCharactersInRange:NSMakeRange(0, 1)];
        if (json[name] != nil) {
            [self setValue:json[name] forKey:name];
        }
    }
    free(ivars);
}


//MARK: --- 交换方法

- (void)test2 {
    Method m1 = class_getInstanceMethod([self class], @selector(run));
    Method m2 = class_getInstanceMethod([self class], @selector(run2));
    
    method_exchangeImplementations(m1, m2);
    
}

@end
