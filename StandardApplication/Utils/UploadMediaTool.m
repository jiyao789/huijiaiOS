//
//  UploadMediaTool.m
//  StandardApplication
//
//  Created by liyuanbo on 2020/4/7.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "UploadMediaTool.h"
#import "MacroDefine.h"
#import "TZImagePickerController.h"
#import "FSPickPhoto.h"
#import "MBProgressHUD+YBDownload.h"
#import "NSURL+YBExstension.h"
#import "UploadFileManager.h"

@implementation UploadMediaToolConfig

@end

@interface UploadMediaTool ()
<
TZImagePickerControllerDelegate
>
@property (nonatomic, assign) UploadMediaSupportType mediaType;
@property (nonatomic, assign) NSInteger maxPhotoNumber;
@property (nonatomic, strong) UIViewController * controller;
@property (nonatomic, copy) void (^finishedHandle) (NSArray *,NSString *);
@property (nonatomic, strong) FSPickPhoto * pickPhoto;
@property (nonatomic, strong) TZImagePickerController * imagePickerVC;
@property (nonatomic, strong) NSMutableArray * mediaUrls;
@property (nonatomic, assign) NSInteger currentUpdateIndex;
@property (nonatomic, strong) MBProgressHUD * hud;
//@property (nonatomic, assign) NSTimeInterval maxTimeInterVal;
@property (nonatomic, strong) UploadMediaToolConfig * mediaConfig;

@end

@implementation UploadMediaTool

+ (void)uploadWithMediaType:(UploadMediaSupportType)mediaType
             maxPhotoNumber:(NSInteger)maxPhotoNumber
             finishedHandle:(void (^) (NSArray * mediaUrls,NSString * errorMsg))finishedHandle;
{
    UploadMediaTool * uploadTool = [[UploadMediaTool alloc] init];
    uploadTool.mediaType = mediaType;
    uploadTool.maxPhotoNumber = maxPhotoNumber;
    uploadTool.finishedHandle = finishedHandle;
    [uploadTool show];
}

+ (void)uploadWithConfig:(void (^)(UploadMediaToolConfig *))config finishedHandle:(void (^)(NSArray *, NSString *))finishedHandle
{
    UploadMediaTool * uploadTool = [[UploadMediaTool alloc] init];
    uploadTool.finishedHandle = finishedHandle;
    
    UploadMediaToolConfig * mediaConfig = [UploadMediaToolConfig new];
    mediaConfig.type = @"all";
    mediaConfig.video = 0;
    mediaConfig.image = 0;
    SAFE_BLOCK(config,mediaConfig);
    uploadTool.mediaConfig = mediaConfig;
    
    [uploadTool show];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxPhotoNumber = 1;
    }
    return self;
}

- (void)setMediaConfig:(UploadMediaToolConfig *)mediaConfig
{
    _mediaConfig = mediaConfig;
    if ([mediaConfig.type isEqualToString:@"all"]) {
        self.mediaType = UploadMediaSupportTypeAll;
    }else if ([mediaConfig.type isEqualToString:@"image"]) {
        self.mediaType = UploadMediaSupportTypeImage;
    }else if ([mediaConfig.type isEqualToString:@"video"]) {
        self.mediaType = UploadMediaSupportTypeVideo;
    }else {
        self.mediaType = UploadMediaSupportTypeAll;
    }
    if (mediaConfig.video > 0) {
        self.pickPhoto.maxVideoDuration = mediaConfig.video * 60;
        self.imagePickerVC.videoMaximumDuration = mediaConfig.video * 60;
    }
}

#pragma mark - actions
- (void)show
{
    if (IsStrEmpty([User shareUser].token)) {
        [MBProgressHUD showMessag:@"请先登录再试" toView:nil];
        return;
    }
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            
            [self gotoSetView:@"操作失败" message:@"无法访问相机，是否前往系统偏好设置开启对应的权限?"] ;
        }else {
            //打开相机
            [self gotoUseCamera];
        }
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BOOL isYx = [self isCanUsePhotos] ;
        
        NSLog(@"%@",isYx ? @"允许" :@"不允许") ;
        if (isYx)
        {
            //打开相册
            [self gotoTakePhotos];
        }else{
            
            [self gotoSetView:@"操作失败" message:@"无法访问相册，是否前往系统偏好设置开启对应的权限?"] ;
        }
    }];
    
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:aleVC animated:YES completion:nil];
}

- (void)gotoUseCamera
{
    NSMutableArray * mediaTypes = [NSMutableArray array];
    if (self.mediaType & UploadMediaSupportTypeImage) {
        [mediaTypes addObject:(NSString *)kUTTypeImage];
    }
    if (self.mediaType & UploadMediaSupportTypeVideo) {
        [mediaTypes addObject:(NSString *)kUTTypeMovie];
    }
    
    if (mediaTypes.count < 1) {
        return;
    }
    
    [self.pickPhoto showTakePhotoWithController:[UIApplication sharedApplication].delegate.window.rootViewController mediaTypes:mediaTypes andWithBlock:^(NSObject *Data) {
        if ([Data isKindOfClass:[UIImage class]]) {
            [self requestUpdateMedia:@[Data] isVideo:NO index:-1];
        }else {
            [self requestUpdateMedia:@[Data] isVideo:YES index:-1];
        }
    }] ;
}

- (void)gotoTakePhotos
{
    if (self.mediaType & UploadMediaSupportTypeImage) {
        self.imagePickerVC.maxImagesCount = self.maxPhotoNumber;
        self.imagePickerVC.allowPickingImage = YES;
    }
    if (self.mediaType & UploadMediaSupportTypeVideo) {
        self.imagePickerVC.allowPickingVideo = YES;
    }
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (BOOL)isCanUsePhotos {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    return YES;
}

- (void)gotoSetView:(NSString *)title message:(NSString *)message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
    message:message     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                                              NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString] ;
                                                                                  if ([[UIApplication sharedApplication] canOpenURL:url])
                                                                                  {
                                                                                      [[UIApplication sharedApplication] openURL:url];//url为具体路径
                                                                                  }
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
            
                                                          }];

    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)getImageCacheSize:(UIImage *)image
{
    return CGImageGetHeight(image.CGImage) * CGImageGetBytesPerRow(image.CGImage);
}

#pragma mark - lazyloads
- (FSPickPhoto *)pickPhoto
{
    if (_pickPhoto == nil) {
        _pickPhoto = [[FSPickPhoto alloc] init] ;
//        _pickPhoto.maxVideoDuration = _maxTimeInterVal;
    }
    return _pickPhoto ;
}

- (NSMutableArray *)mediaUrls
{
    if (!_mediaUrls) {
        _mediaUrls = [NSMutableArray array];
    }
    return _mediaUrls;
}

- (TZImagePickerController *)imagePickerVC
{
    if (!_imagePickerVC) {
        _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        _imagePickerVC.allowCrop = NO;
        _imagePickerVC.allowPickingOriginalPhoto = NO;
        _imagePickerVC.allowTakeVideo = NO;
        _imagePickerVC.allowTakePicture = NO;
        _imagePickerVC.allowPickingMultipleVideo = NO;
        _imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
        _imagePickerVC.allowPickingVideo = NO;
        _imagePickerVC.allowPickingImage = NO;
//        _imagePickerVC.videoMaximumDuration = _maxTimeInterVal;
        
        @weakify(self)
        [_imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            @strongify(self)
            [self uploadMedias:photos];
        }];
        
        [_imagePickerVC setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
            
            if ([self isHaveCacheFileWithIdentifier:asset.localIdentifier]) {
                //有缓存
                NSDictionary * cacheDic = [self getCacheWithIdentifier:asset.localIdentifier];
                NSString * fileUrlName = cacheDic[@"fileUrlName"];
                if (fileUrlName) {
                    NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileUrlName];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        NSURL * url = [NSURL fileURLWithPath:path];
                        NSString * identifier = asset.localIdentifier;
                        url.fileIdentifier = identifier;
                        [self uploadMedias:url];
                        return;
                    }
                }
            }
            
            [MBProgressHUD showStatus:@"正在导出视频..." toView:nil];
            
            [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetHighestQuality success:^(NSString *outputPath) {
                
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
                NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
                
                NSURL * url = [NSURL fileURLWithPath:outputPath];
                NSString * identifier = asset.localIdentifier;
                url.fileIdentifier = identifier;
                [self uploadMedias:url];
                    
            } failure:^(NSString *errorMessage, NSError *error) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
                NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
            }];
        }];
    }
    return _imagePickerVC;
}

- (BOOL)isHaveCacheFileWithIdentifier:(NSString *)identifier
{
    if (IsStrEmpty(identifier)) {
        return NO;
    }
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * cachePath = [NSTemporaryDirectory() stringByAppendingString:@"YDFileUploadRecorder"];
    NSArray * caches = [fileManager contentsOfDirectoryAtPath:cachePath error:nil];
    
    NSDictionary * resultDic = [self getCacheWithIdentifier:identifier];
    NSString * cacheName = resultDic[@"storageName"];
    
    return [caches containsObject:cacheName];
}

- (NSDictionary *)getCacheWithIdentifier:(NSString *)identifier
{
    if (IsStrEmpty(identifier)) {
        return nil;
    }
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userInfoDic = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"UpLoadCache"]];
    return userInfoDic[identifier];
}

#pragma mark - TZImagePickerControllerDelegate
- (BOOL)isAssetCanSelect:(PHAsset *)asset
{
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        if (self.mediaConfig.video > 0 &&
            asset.duration > self.mediaConfig.video * 60) {
            NSLog(@"过滤的视频时长 %.0lf min",asset.duration / 60.0);
            return NO;
        } else {
            return YES;
        }
    }else if (asset.mediaType == PHAssetMediaTypeImage) {
        return YES;
    }else {
        return YES;
    }
}

#pragma mark - data
- (void)uploadMedias:(id)medias
{
    if ([medias isKindOfClass:[NSArray class]]) {
        //图片数组
        self.currentUpdateIndex = 0;
        NSArray * mediaArray = (NSArray *)medias;
        if (mediaArray.count == 1) {
            [self requestUpdateMedia:mediaArray isVideo:NO index:-1];
        }else {
            [self requestUpdateMedia:mediaArray isVideo:NO index:self.currentUpdateIndex];
        }
        
    } else if ([medias isKindOfClass:[NSURL class]]) {
        //视频
        [self requestUpdateMedia:@[medias] isVideo:YES index:-1];
    }
}

- (void)requestUpdateMedia:(NSArray *)meidas isVideo:(BOOL)isVideo index:(NSInteger)index
{
    NSMutableArray *nameArr = [NSMutableArray array];
    self.hud = [MBProgressHUD showDownloadHudAddTo:[UIApplication sharedApplication].delegate.window animated:YES];
    if (isVideo) {
        NSString *nameStr = [NSString stringWithFormat:@"%u_%@.mp4",arc4random_uniform(100),[NSDate date]];
        self.hud.detailsLabel.text = [NSString stringWithFormat:@"\n正在上传视频"];
        [nameArr addObject:nameStr];
    }else {
        self.hud.detailsLabel.text = [NSString stringWithFormat:@"\n正在上传图片"];
        for (NSInteger i = 0; i < meidas.count; i ++) {
            NSString *nameStr = [NSString stringWithFormat:@"%u_%@.png",arc4random_uniform(100),[NSDate date]];
            [nameArr addObject:nameStr];
            id mediaData = meidas[i];
            //图片大小限制
            if (self.mediaConfig.image > 0) {
                CGFloat imageSize = [self getImageCacheSize:mediaData]  / 1024.0 / 1024.0;
                NSLog(@"上传的图片大小 = %lf M",imageSize);
                if (imageSize > self.mediaConfig.image) {
                    [self.hud hideAnimated:NO];
                    [MBProgressHUD showMessag:[NSString stringWithFormat:@"图片不能超过%ldM",self.mediaConfig.image] toView:nil];
                    return;
                }
            }
        }
    }
    
    KWeakSelf
    [[UploadFileManager shareManager] uploadData:nameArr upFile:meidas progress:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud.button setTitle:@"取消" forState:UIControlStateNormal];
            weakSelf.hud.progress = progress;
            if (progress == 1) {
                weakSelf.hud.detailsLabel.text = @"正在处理...";
            }
        });
    } backData:^(NSArray * _Nonnull urlArr, NSString * _Nonnull message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
        });
        if (urlArr.count > 0) {
            for (NSDictionary *urlDic in urlArr) {
                NSString * url = urlDic[@"url"];
                if (!IsStrEmpty(url)) {
                    NSDictionary * jsonDic = @{
                        @"success" : @(YES),
                        @"msg" : @"上传成功",
                        @"obj" : url,
                        @"attributes" : @""
                    };
                    NSString * jsonStr = [jsonDic mj_JSONString];
                    [self.mediaUrls addObject:jsonStr];
                } else {
                    NSDictionary * jsonDic = @{
                        @"success" : @(NO),
                        @"msg" : message ?: @"",
                        @"obj" : @"",
                        @"attributes" : @""
                    };
                    NSString * jsonStr = [jsonDic mj_JSONString];
                    [self.mediaUrls addObject:jsonStr];
                }
            }
            SAFE_BLOCK(self.finishedHandle,self.mediaUrls,nil);
        } else {
            NSDictionary * jsonDic = @{
                @"success" : @(NO),
                @"msg" : message ?: @"",
                @"obj" : @"",
                @"attributes" : @""
            };
            NSString * jsonStr = [jsonDic mj_JSONString];
            SAFE_BLOCK(self.finishedHandle,nil,jsonStr);
        }
    }];
}

@end
