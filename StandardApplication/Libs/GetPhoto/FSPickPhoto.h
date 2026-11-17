//
//  ZYPickPhoto.h
//  QCProject
//
//  Created by chao on 2017/4/17.
//  Copyright © 2017年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//访问相册和相机
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

/**
 *  回调Block
 *
 *  @param Data 返回值
 */
typedef void(^myblock)(NSObject * Data);

/**
 *  相册选择
 */
@interface FSPickPhoto : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 *  相册选择器
 */
@property (nonatomic,strong) UIImagePickerController *picker;

/**
 最长录影时间
 */
@property (nonatomic, assign) NSTimeInterval maxVideoDuration;

/**
 *  block
 */
@property (nonatomic,strong) myblock  myblock;

/**
 *  打开相机：
 *
 *  @param object 控制器对象
 */
    
- (void)showTakePhotoWithController: (UIViewController *)Controller
                     mediaTypes: (NSArray *)mediaTypes
                       andWithBlock: (myblock)block;

/**
 *  选择相册
 *
 *  @param Controller 控制器对象
 */
- (void)showLocalPhotoWithController: (UIViewController *)Controller
                          mediaTypes: (NSArray *)mediaTypes
                        andWithBlock: (myblock)block;
    
- (void)SHowLocalPhotoWithController: (UIViewController *)Controller
                        andWithBlock: (myblock)block;
@end
