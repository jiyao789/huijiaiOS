//
//  CYXCameraViewController.m
//  CYXCustomerCameraDemo
//
//  Created by 超级腕电商 on 2019/2/22.
//  Copyright © 2019年 超级腕电商. All rights reserved.
//

#import "CYXCameraViewController.h"
#import "CYXCameraShadowView.h"
//导入相机框架
#import <AVFoundation/AVFoundation.h>
//将拍摄好的照片写入系统相册中，所以我们在这里还需要导入一个相册需要的头文件iOS8
#import <Photos/Photos.h>

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface CYXCameraViewController ()
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

// ------------- UI --------------
//拍照按钮
@property (nonatomic)UIButton *photoButton;
//闪光灯按钮
@property (nonatomic)UIButton *flashButton;
//聚焦
@property (nonatomic)UIView *focusView;
//是否开启闪光灯
@property (nonatomic)BOOL isflashOn;
/*遮罩*/
@property (nonatomic,strong) CYXCameraShadowView *shadowView;
@end

@implementation CYXCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    if ( [self checkCameraPermission]) {
        [self customCamera];
        [self initSubViews];
        
        [self focusAtPoint:CGPointMake(0.5, 0.5)];
        
    }
    
    
    
}
- (void)customCamera{
    [self.view.layer addSublayer:self.previewLayer];
    //开始启动
    [self.session startRunning];
    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        //闪光灯自动
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        //解锁
        [self.device unlockForConfiguration];
    }
}
-(void)setIsCardFront:(BOOL)isCardFront{
    _isCardFront = isCardFront;
    self.shadowView.shadowIamgeView.image =[UIImage imageNamed:isCardFront?@"cardShadowFront":@"cardShadowBack"];
}
- (void)initSubViews{
    [self.view addSubview:self.shadowView];
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(KScreenWidth-44-16, 32, 44, 44);
    [btn setImage:[UIImage imageNamed:@"cameraClose"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    [self.view addSubview:self.photoButton];

    [self.view addSubview:self.focusView];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self->_focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self->_focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self->_focusView.hidden = YES;
            }];
        }];
    }
    
}

- (void)FlashOn{
    
    if ([_device lockForConfiguration:nil]) {
        if (_isflashOn) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                _isflashOn = NO;
                [_flashButton setTitle:@"闪光灯关" forState:UIControlStateNormal];
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                _isflashOn = YES;
                [_flashButton setTitle:@"闪光灯开" forState:UIControlStateNormal];
            }
        }
        
        [_device unlockForConfiguration];
    }
}

- (void)changeCamera{
    //获取摄像头的数量
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //摄像头小于等于1的时候直接返回
    if (cameraCount <= 1) return;
    
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    //获取当前相机的方向(前还是后)
    AVCaptureDevicePosition position = [[self.input device] position];
    
    //为摄像头的转换加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
    
    if (position == AVCaptureDevicePositionFront) {
        //获取后置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
    }else{
        //获取前置摄像头
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    }
    
    [self.previewLayer addAnimation:animation forKey:nil];
    //输入流
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    
    
    if (newInput != nil) {
        
        [self.session beginConfiguration];
        //先移除原来的input
        [self.session removeInput:self.input];
        
        if ([self.session canAddInput:newInput]) {
            [self.session addInput:newInput];
            self.input = newInput;
            
        } else {
            //如果不能加现在的input，就加原来的input
            [self.session addInput:self.input];
        }
        
        [self.session commitConfiguration];
        
    }
    
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}


#pragma mark- 拍照
- (void)shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection ==  nil) {
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer == nil) {
            return;
        }
        
        NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self saveImageWithImage:[UIImage imageWithData:imageData]];
        
        
    }];
    
}
/**
 * 保存图片到相册
 */
- (void)saveImageWithImage:(UIImage *)image {
    CGFloat kX =self.shadowView.kMarginX;
    CGFloat kY = self.shadowView.kMarginY;
    CGRect  cutRect =CGRectMake(kX, kY, self.shadowView.frame.size.width-kX*2, self.shadowView.frame.size.height-kY*2);
    CGFloat scaleY = self.shadowView.frame.size.width/image.size.width;
    CGFloat scaleX = self.shadowView.frame.size.height/image.size.height;
    image =[self ct_imageFromImage:image inRect:cutRect scaleX:scaleX scaleY:scaleY];
    
    if ([self.delegate respondsToSelector:@selector(cameraDidSelectedIdcardPhotoImage:)]) {
        [self.delegate cameraDidSelectedIdcardPhotoImage:image];
        [self disMiss];
    }
    // 判断授权状态   // 可以直接上传，代码可注销
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                NSLog(@"保存失败：%@", error);
                return;
            }else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功剪裁并保存至相册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag = 100;
                [alertView show];
            }
        });
    }];
}
/**
 从图片中按指定的位置大小截取图片的一部分
 
 @param image image UIImage image 原始的图片
 @param rect CGRect rect 要截取的区域
 @param scaleX scaleX
 @param scaleY scaleY
 @return UIImage
 */
- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect scaleX:(CGFloat )scaleX scaleY:(CGFloat )scaleY{
    //这里因为不是横屏布局 所以需要横纵坐标变换一下
    
    CGFloat origX = (rect.origin.y - 0) / scaleX;
    CGFloat origY = (rect.origin.x - 0) / scaleY;
    
    CGFloat oriWidth = rect.size.height / scaleX;
    CGFloat oriHeight = rect.size.width / scaleY;
    
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
    CGImageRef  imageRef = CGImageCreateWithImageInRect(image.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    return clipImage;
    
}




- (void)disMiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark- 检测相机权限
- (BOOL)checkCameraPermission
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
    
    if (buttonIndex == 1 && alertView.tag == 100) {
        
        [self disMiss];
    }
    
}
#pragma mark ---G
-(AVCaptureDevice*)device{
    if(!_device){
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}
-(AVCaptureDeviceInput*)input{
    if(!_input){
        _input= [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    }
    return _input;
}
-(AVCaptureStillImageOutput*)ImageOutPut{
    if(!_ImageOutPut){
        _ImageOutPut= [[AVCaptureStillImageOutput alloc]init];
    }
    return _ImageOutPut;
}
-(AVCaptureSession*)session{
    if(!_session){
        _session= [[AVCaptureSession alloc]init];
        if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [_session setSessionPreset:AVCaptureSessionPreset1280x720];
        }
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.ImageOutPut]) {
            [_session addOutput:self.ImageOutPut];
        }
    }
    return _session;
}
-(AVCaptureVideoPreviewLayer*)previewLayer{
    if(!_previewLayer){
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}
-(UIButton*)photoButton{
    if(!_photoButton){
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = CGRectMake(KScreenWidth/2.0-30, KScreenHeight-100, 60, 60);
        [_photoButton setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}
-(UIView*)focusView{
    if(!_focusView){
        _focusView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor = [UIColor greenColor].CGColor;
        _focusView.hidden = YES;
    }
    return _focusView;
}
-(CYXCameraShadowView*)shadowView{
    if(!_shadowView){
        _shadowView = [[CYXCameraShadowView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    }
    return _shadowView;
}

@end
