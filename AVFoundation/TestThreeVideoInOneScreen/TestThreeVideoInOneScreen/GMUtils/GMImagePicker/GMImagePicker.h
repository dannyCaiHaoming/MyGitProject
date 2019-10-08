//
//  GMImagePicker.h
//  LittleMaster
//
//  Created by Gemo on 16/2/24.
//  Copyright © 2016年 Gemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GMImagePickerDelegate;

/**
 *  图片选择类，对系统的UIImagePickerController类进行封装
 */
@interface GMImagePicker : NSObject

/// delegate对象
@property (weak, nonatomic) id<GMImagePickerDelegate> delegate;
/// 是否开启UIImagePickerController的编辑功能
@property (assign, nonatomic) BOOL allowsEditing;

/**
 *  打开系统摄像头
 *
 *  @param controller 在此View controller弹出系统摄像头界面
 *
 */
- (void)showImagePickerThroughCameraFrom:(UIViewController *)controller;

/**
 *  打开系统的图片相册
 *
 *  @param controller 在此View controller弹出图片相册选择界面
 *
 */
- (void)showImagePickerThroughAlbumFrom:(UIViewController *)controller;

@end

@protocol GMImagePickerDelegate <NSObject>

@required
- (void)imagePicker:(GMImagePicker *)imagePicker didFinishPickingImage:(UIImage *)image;

@optional
- (void)imagePickerDidCancelPickingImage:(GMImagePicker *)imagePicker;

@end
