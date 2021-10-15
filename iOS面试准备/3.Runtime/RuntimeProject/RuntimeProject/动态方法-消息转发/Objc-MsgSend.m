//
//  Objc-MsgSend.m
//  RuntimeProject
//
//  Created by 蔡浩铭 on 2021/10/15.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "Objc-MsgSend.h"
#import <objc/runtime.h>

@interface ForwardingTarget : NSObject

//- (void)instance_forwardingMethod;
//+ (void)class_forwardingMethod;

@end

@implementation ForwardingTarget

- (void)test {
    NSLog(@"instance_forwardingMethod");
}

+ (void)test {
    NSLog(@"class_forwardingMethod");
}

@end

@implementation Objc_MsgSend


void test_c() {
    printf("test_c()");
}

- (void)objc_c {
    NSLog(@"objc_c()");
}

//MARK: -- 动态解析
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(test)) {
//
////        class_addMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>, <#IMP  _Nonnull imp#>, <#const char * _Nullable types#>)
////        class_addMethod(self, sel, (void *)test_c, "v@:");
//
//        Method method = class_getInstanceMethod(self, @selector(objc_c));
//
//        class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
//
//        return YES;
//    }
//
//    return [super resolveInstanceMethod:sel];
//}

// MARK: -- 消息转发
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return  [ForwardingTarget new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return  objc_getClass("ForwardingTarget");//[ForwardingTarget new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    if (sel == @selector(test)) {
        [anInvocation invokeWithTarget:[ForwardingTarget new]];
        return;;
    }
    [super forwardInvocation:anInvocation];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    if (sel == @selector(test)) {
        [anInvocation invokeWithTarget:[ForwardingTarget class]];
        return;;
    }
    [super forwardInvocation:anInvocation];
}

@end
