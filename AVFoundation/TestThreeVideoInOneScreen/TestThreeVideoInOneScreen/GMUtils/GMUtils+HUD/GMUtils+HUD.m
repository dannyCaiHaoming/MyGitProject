//
//  GMUtils+HUD.m
//  Gemo.com
//
//  Created by Horace.Yuan on 15/9/22.
//  Copyright (c) 2015年 gemo. All rights reserved.
//

#import "GMUtils+HUD.h"

//#import <FLAnimatedImage/FLAnimatedImage.h>

@implementation GMUtils (HUD)

+ (void)showQuickTipWithText:(NSString *)text
{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.detailsLabel.font = [UIFont systemFontOfSize:12];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.numberOfLines = 0;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:2.0f];
}

+ (void)showQuickTipWithText:(NSString *)text afterDelay:(CGFloat)afterDelay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.detailsLabel.font = [UIFont systemFontOfSize:12];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.numberOfLines = 0;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:afterDelay];
}


+ (void)showQuickTipWithTitle:(NSString *)title withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                              animated:YES];
    [hud setMode:MBProgressHUDModeText];
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.detailsLabel.font = [UIFont systemFontOfSize:12];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.numberOfLines = 0;
    hud.label.text = title;
    hud.detailsLabel.text = text;
    [hud hideAnimated:YES afterDelay:2.0f];
}

+ (void)showWaitingHUDInKeyWindow
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow
                         animated:YES];
}

+ (void)hideAllWaitingHUDInKeyWindow;
{
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow
                         animated:YES];
    //[MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

+ (MBProgressHUD *)showWaitingHUDInView:(UIView *)view;
{
    return ([MBProgressHUD showHUDAddedTo:view animated:YES]);
}

+ (void)hideAllWaitingHudInView:(UIView *)view;
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    //[MBProgressHUD hideAllHUDsForView:view animated:YES];
}


+ (void)showTipsWithHUD:(NSString *)labelText
               showTime:(CGFloat)time
              usingView:(UIView *)view
{
    [[self class] showTipsWithHUD:labelText showTime:time usingView:view yOffset:0.0f];
}

+ (void)showTipsWithHUD:(NSString *)labelText
               showTime:(CGFloat)time
              usingView:(UIView *)view
                yOffset:(CGFloat)yOffset
{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[[[UIApplication sharedApplication] delegate] window]];
    hud.offset = CGPointMake(hud.offset.x, yOffset);
    hud.mode = MBProgressHUDModeText;
    hud.label.text = labelText;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.detailsLabel.font = [UIFont systemFontOfSize:12];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [view addSubview:hud];
    
    [hud hideAnimated:YES afterDelay:time];
    
}

+ (void)showTipsWithHUD:(NSString *)labelText
               showTime:(CGFloat)time
           withFontSize:(CGFloat)fontSize
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:[[[UIApplication sharedApplication] delegate] window]];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = labelText;
    hud.label.font = [UIFont systemFontOfSize:fontSize];
    hud.detailsLabel.font = [UIFont systemFontOfSize:fontSize-2];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hideAnimated:YES afterDelay:time];
}

+ (MBProgressHUD *)showTipsWithHUD:(NSString *)labelText
               showTime:(CGFloat)time
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:[[[UIApplication sharedApplication] delegate] window]];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = labelText;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.detailsLabel.font = [UIFont systemFontOfSize:12];
    hud.label.numberOfLines = 0;
    hud.detailsLabel.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:hud];
    
    [hud hideAnimated:YES afterDelay:time];
    return hud;
}

//+ (void)showGifToView:(UIView *)view {
//    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    
//    //使用SDWebImage 放入gif 图片
//    
////    UIImage *image = [UIImage s
////                      sd_animatedGIFNamed:@"load_antion"];
//    FLAnimatedImageView *imgView = [FLAnimatedImageView new];
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
//    imgView.frame = CGRectMake(30, 20, 37.5, 20);
//    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"合成-1" ofType:@"gif"];
//    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
//    imgView.backgroundColor = [UIColor clearColor];
//    imgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
//    
//    //自定义imageView
////    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
//    
//    //设置hud模式
//    hud.mode = MBProgressHUDModeCustomView;
//    
//    //设置在hud影藏时将其从SuperView上移除,自定义情况下默认为NO
//    hud.removeFromSuperViewOnHide = YES;
//    
//    //设置方框view为该模式后修改颜色才有效果
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    
//    //设置方框view背景色
//    hud.bezelView.backgroundColor = [UIColor clearColor];
//    //设置总背景view的背景色，并带有透明效果
//    hud.backgroundColor = [UIColor clearColor];
//    hud.customView = imgView;
//}
//
//
//+ (void)hideGifToView:(UIView *)view {
//    [MBProgressHUD hideHUDForView:view animated:YES];
//}

@end
