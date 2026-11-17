//
//  ZYPickPhoto.m
//  QCProject
//
//  Created by chao on 2017/4/17.
//  Copyright © 2017年 C. All rights reserved.
//

#import "FSPickPhoto.h"
#import "UIImage+FixOrientation.h"
#import "MacroDefine.h"

@implementation FSPickPhoto


- (instancetype)init
{
    if (self = [super init])
    {
        _picker = [[UIImagePickerController alloc] init];
        _maxVideoDuration = 20;
    }
    return self;
}

/**
 *  打开相机：
 *
 *  @param object 控制器对象
 */
- (void)showTakePhotoWithController: (UIViewController *)Controller
                         mediaTypes: (NSArray *)mediaTypes
                       andWithBlock: (myblock)block
{
    //回调
    _myblock = block;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;

    _picker.mediaTypes = mediaTypes ;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        _picker.delegate = self;
        
        //设置拍照后的图片可被编辑
        
        _picker.allowsEditing = NO;
        _picker.videoMaximumDuration = self.maxVideoDuration;

        _picker.sourceType = sourceType;
        
        [Controller presentViewController:_picker animated:YES completion:nil];
        
    }
    else
    {
//        DebugLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
    
}

/**
 *  选择相册
 *
 *  @param Controller 控制器对象
 */
    
- (void)showLocalPhotoWithController: (UIViewController *)Controller
                          mediaTypes: (NSArray *)mediaTypes
                        andWithBlock: (myblock)block
{
    _myblock = block;
    //    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    _picker.mediaTypes = mediaTypes ;
    
//    _picker.videoMaximumDuration = 300;
    _picker.delegate = self;
    
    //设置选择后的图片可被编辑
//    _picker.allowsEditing = YES;
    
    [Controller presentViewController:_picker animated:YES completion:nil];
}
    
- (void)SHowLocalPhotoWithController: (UIViewController *)Controller
                        andWithBlock: (myblock)block
{
    _myblock = block;
//    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeAudiovisualContent,(NSString *)kUTTypeImage];
//    _picker.videoMaximumDuration = 15;
    _picker.delegate = self;
    
    //设置选择后的图片可被编辑
    
//    _picker.allowsEditing = YES;
    
    [Controller presentViewController:_picker animated:YES completion:nil];
}
    
    


//当一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    [_picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //图片可编辑
//        UIImage *newHeaderImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //压缩图片，控制内存
        UIImage *newHeaderImage =  [self processImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        newHeaderImage = [newHeaderImage fixOrientation];
        
        if (_myblock)
        {
            
            _myblock(newHeaderImage);
            
            newHeaderImage = nil;
            [_picker dismissViewControllerAnimated:YES completion:nil];
        }
        
        
    }else  if ([type isEqualToString:@"public.movie"])
    {
        NSLog(@"进入视频环节!!!");
        NSURL *URL = info[UIImagePickerControllerMediaURL];
        NSData *file = [NSData dataWithContentsOfURL:URL];
        NSLog(@"输出视频的大小:%lu",(unsigned long)[file length]);
        
        if (_myblock){
            _myblock(URL);
            
            [_picker dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
}
    
// 取消选择照片:
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
//    DebugLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//如果要上传到服务器，最好在压缩一下UIImageJPEGRepresentation(image, 0-1)
- (UIImage *)processImage:(UIImage *)image {
    CGFloat hFactor = image.size.width / SCREEN_WIDTH;
    CGFloat wFactor = image.size.height / SCREEN_HEIGHT;
    CGFloat factor = fmaxf(hFactor, wFactor);
    CGFloat newW = image.size.width / factor;
    CGFloat newH = image.size.height / factor;
    CGSize newSize = CGSizeMake(newW, newH);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newW, newH)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
