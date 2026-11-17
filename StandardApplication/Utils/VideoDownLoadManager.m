//
//  VideoDownLoadManager.m
//  StandardApplication
//
//  Created by liyuanbo on 2019/11/22.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "VideoDownLoadManager.h"
#import "MBProgressHUD+YBDownload.h"
#import "MacroDefine.h"

@interface VideoDownLoadManager ()

@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, copy) NSString * cacheUrlPath;

@end

@implementation VideoDownLoadManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static VideoDownLoadManager * manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[VideoDownLoadManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return manager;
}

- (void)downloadWithUrl:(NSString *)url
{
    if (IsStrEmpty(url)) {
        return;
    }
    NSLog(@"视频下载链接=======%@",url);
    self.hud = [MBProgressHUD showDownloadHudAddTo:[UIApplication sharedApplication].delegate.window animated:YES];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionTask * task = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = (float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount;
            self.hud.progress = progress;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString * cachePath = [self cachePath];
        NSString * fileName = response.suggestedFilename;
        NSString * pathExtension = fileName.pathExtension;
        if (IsStrEmpty(pathExtension)) {
            fileName = [fileName stringByAppendingString:@".mp4"];
        }
        return [NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:fileName]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
            if (error) {
                [MBProgressHUD showMessag:@"下载失败" toView:[UIApplication sharedApplication].delegate.window];
            }else {
                [self saveVideoToAlbumWithFilePath:filePath];
            }
        });
    }];
    
    [task resume];
}

- (void)saveVideoToAlbumWithFilePath:(NSURL *)url
{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    if (url) {
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }else {
            [MBProgressHUD showMessag:@"该资源无法存入相册" toView:window];
        }
        self.cacheUrlPath = [url path];
    }
}

//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
        [MBProgressHUD showMessag:@"保存视频失败" toView:nil];
    }
    else {
        NSLog(@"保存视频成功");
        [MBProgressHUD showMessag:@"下载成功，请到系统相册查看" toView:nil];
    }
    
    //删除缓存的视频
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.cacheUrlPath]) {
        [fileManager removeItemAtPath:self.cacheUrlPath error:nil];
        self.cacheUrlPath = nil;
    }
}

- (NSString *)cachePath
{
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"cachedVideos"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

- (void)downloadVideoWithURL:(NSString *)url progress:(void (^)(double))progressHandle completed:(void (^)(NSString * _Nonnull))completedHandle
{
    if (IsStrEmpty(url)) {
        return;
    }
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionTask * task = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        double progress = (double)downloadProgress.completedUnitCount / (double)downloadProgress.totalUnitCount;
        SAFE_BLOCK(progressHandle,progress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString * cachePath = [VideoDownLoadManager launchAdVideoPath];
        NSString * fileName = response.suggestedFilename;
        NSString * pathExtension = fileName.pathExtension;
        if (IsStrEmpty(pathExtension)) {
            fileName = [fileName stringByAppendingString:@".mp4"];
        }
        return [NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:fileName]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSString *urlPath = [filePath path];
        NSUInteger pos = [urlPath rangeOfString:@"/" options:NSBackwardsSearch].location;
        urlPath = [urlPath substringFromIndex:pos+1];
        SAFE_BLOCK(completedHandle,urlPath);
    }];
    
    [task resume];
}

+ (NSString *)launchAdVideoPath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cachedVideos"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
