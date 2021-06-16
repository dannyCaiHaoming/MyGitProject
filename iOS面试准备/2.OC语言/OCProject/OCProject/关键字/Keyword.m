//
//  Keyword.m
//  OCProject
//
//  Created by Danny on 2021/6/16.
//  Copyright © 2021 蔡浩铭. All rights reserved.
//

#import "Keyword.h"

@interface Keyword ()
/*
 1.  nonatomic  atomic
 2.  strong  copy
 3.  weak  unsafe_unretained
 4.  assign
 5.  readwrite  readonly
 */

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *cString;

@property (nonatomic, strong) NSString *sString;

@property (nonatomic, weak) NSString *unsafeString;

@property (nonatomic, unsafe_unretained) NSArray *unsafeArray;

@property (nonatomic, weak) NSString *weakString;

@property (nonatomic, assign) int integer;


@end

@implementation Keyword


- (void)keyword {
    
    self.weakString = [[NSString alloc] initWithString:@"123"];

//    self.weakString = self.sString;

    self.unsafeString = self.weakString;

    self.weakString = nil;
    
    
    __unsafe_unretained NSArray *a = [NSArray arrayWithObject:@"132"];
    
    NSLog(@"%@",a);
    
    self.unsafeArray = a;
    
//    NSLog(@"sString = %@,wString = %@,unsafeString = %@",self.sString,self.weakString,self.unsafeString);
    
//    self.array = [NSArray array];
//
//    self.unsafeArray = self.array;
//
//    self.array = nil;
//
//    [self.unsafeArray count];
    

    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * 0.5), dispatch_get_main_queue(), ^{
        [self afterDo];
    });
}

- (void)afterDo {
    [self.unsafeString boolValue];
}

@end
