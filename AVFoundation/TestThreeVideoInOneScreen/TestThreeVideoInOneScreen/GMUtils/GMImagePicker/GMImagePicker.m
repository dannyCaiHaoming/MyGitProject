//
//  GMImagePicker.m
//  LittleMaster
//
//  Created by Gemo on 16/2/24.
//  Copyright © 2016年 Gemo. All rights reserved.
//

#import "GMImagePicker.h"

@interface GMImagePicker()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation GMImagePicker

- (void)showImagePickerThroughCameraFrom:(UIViewController *)controller{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.allowsEditing          = self.allowsEditing;
        self.imagePicker.sourceType             = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.delegate               = self;
        self.imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        [controller presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }
}

- (void)showImagePickerThroughAlbumFrom:(UIViewController *)controller{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = self.allowsEditing;
    self.imagePicker.sourceType    = sourceType;
    self.imagePicker.delegate      = self;
    self.imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [controller presentViewController:self.imagePicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = nil;
    if (picker.allowsEditing) {
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }
    
    if (image == nil) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    if (self.delegate) {
        [self.delegate imagePicker:self didFinishPickingImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.delegate) {
            [self.delegate imagePickerDidCancelPickingImage:self];
        }
    }];
}
@end
