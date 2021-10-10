//
//  ViewController.m
//  BlockProject
//
//  Created by Danny on 2019/9/17.
//  Copyright © 2019 Danny. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Test.h"
#import "BlockMemoryLayout.h"


typedef void(^TestBlock)(void);

@interface ViewController (){
	NSObject *object;
}

@property (nonatomic, copy) TestBlock block;
@property (nonatomic, strong) Person *p;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.p = [[Person alloc] init];
//    self.p.hold = self;
    
//    [Person share].hold = self;
//    [[Person share] setHoldBlock:^{
//        NSLog(@"%@",self);
//     }];
    
    [[Person share].dicts setValue:self forKey:@"self"];
    
//	Person *person = [[Person alloc] init];
////
//    [person initBlock];
////	//
////	person.testBlock();
//    [person executeBlock];
//	object = [NSObject new];
//
//	__weak typeof(self) weakSelf = self;
//	self.block = [^{
//
//		//若引用  因此临时变量weakself被释放
////		__strong typeof(self) strongSelf = weakSelf;
//
//		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 3), dispatch_get_main_queue(), ^{
//
//
//
////			NSLog(@"%@----%@",weakSelf,strongSelf);
//			[weakSelf test];
////			[strongSelf test];
//		});
//	} copy];
//
//	self.block();
    
    
//    Test *test = [Test new];
//    [test print];
    
    
    [[[BlockMemoryLayout alloc] init] find];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
	
//	object = nil;
    [self.navigationController popViewControllerAnimated:true];
}

- (void)dealloc{
    NSLog(@"ViewController dealloc");
}


- (void)test {
	NSLog(@"test");
}

//- (void)test {
//
//}

@end
