//
//  UploadFileManager.m
//  StandardApplication
//
//  Created by DTiOS on 2020/8/3.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "UploadFileManager.h"
#import "MacroDefine.h"
#import <QiniuSDK.h>

@interface UploadFileManager ()
//上传失败个数
@property (assign, nonatomic) NSInteger uploadFileNumber;
@end

@implementation UploadFileManager

static UploadFileManager *DefaultManager = nil;

+ (UploadFileManager *)shareManager{
    if (!DefaultManager){
        DefaultManager = [[self allocWithZone:NULL] init];
    }
    return DefaultManager;
}

- (void)setCancelUpload:(BOOL)cancelUpload
{
    _cancelUpload = cancelUpload;
}

//上传资源-步骤1【需要token】
-(void)uploadData:(NSArray *)nameArr upFile:(NSArray *)file progress:(void (^) (double progress))progressBlock backData:(void(^)(NSArray *urlArr,NSString *message))callBakcEvent{

    _uploadFileNumber = 0;
    self.callBackEvent = callBakcEvent;
    self.progressHandle = progressBlock;
    [self uploadTokens:nameArr upFile:file];
}

- (void)uploadTokens:(NSArray *)nameArr upFile:(NSArray *)file
{
//    [HttpRequest requestArrUrlPath:get_upload_tokens parameters:@{@"fileNames":nameArr} type:HttpRequestTypePost result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
//        if (status == 1) {
//            [self uploafile:arr upFile:file];
//        } else {
//            self.callBackEvent([NSArray array],msg);
//        }
//    }];
}


//上传资源-步骤2（由APP实现）
-(void)uploafile:(NSArray *)tokensArr upFile:(NSArray *)file{

    NSMutableArray *materialIdArr = [NSMutableArray array];
    if (tokensArr.count != file.count) {
        self.callBackEvent([NSArray array],@"上传失败，请重试");
        return;
    }
    
    for (int i = 0; i < tokensArr.count; i ++) {
        NSDictionary *dic = tokensArr[i];
        
        NSString *uploadToken = [dic objectForKey:@"uploadToken"];
        NSString *storageName = [dic objectForKey:@"storageName"];

        NSString *pathStr = [NSTemporaryDirectory() stringByAppendingString:@"rmt_fengxian"];
        QNFileRecorder *fileRecorder = [QNFileRecorder fileRecorderWithFolder:pathStr error:nil];
        
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.useConcurrentResumeUpload = NO; // 默认为NO
            builder.concurrentTaskCount = 3; // 默认并行线程数为3
            builder.zone = [[QNFixedZone alloc]initWithupDomainList:@[@"up-qos.storage.shmedia.tech"]];
            builder.recorder = fileRecorder;
        }];
        QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
        
        KWeakSelf
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            KStrongSelf(weakSelf)
            SAFE_BLOCK(strongSelf.progressHandle,percent);
        } params:nil checkCrc:NO cancellationSignal:^BOOL{
            return _cancelUpload;
        }];
                
        if ([file[i] isKindOfClass:[UIImage class]]) {
            NSData *imageData = UIImageJPEGRepresentation(file[i], 1);
            [upManager putData:imageData key:storageName token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (!IsNilOrNull(resp)) {
                    NSDictionary *dicitem = [resp objectForKey:@"data"];
                    if ([dicitem.allKeys containsObject:@"materialId"]) {
                        NSString *materialId = [NSString stringWithFormat:@"%@",[dicitem objectForKey:@"materialId"]];
                        NSDictionary *respDic = @{@"storageName":storageName,
                                                  @"materialId":materialId};
                        [materialIdArr addObject:respDic];
                        
                        if (materialIdArr.count == (tokensArr.count - weakSelf.uploadFileNumber)) {
                            [self geturlmaterialId:materialIdArr];
                        }
                    }
                } else {
                    weakSelf.uploadFileNumber ++;
                }
            } option:uploadOption];
        } else if ([file[i] isKindOfClass:[NSURL class]]) {
            NSURL *pathUrl = (NSURL *)file[i];
            [upManager putFile:pathUrl.path key:storageName token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (!IsNilOrNull(resp)) {
                    NSDictionary *dicitem = [resp objectForKey:@"data"];
                    if ([dicitem.allKeys containsObject:@"materialId"]) {
                        NSString *materialId = [NSString stringWithFormat:@"%@",[dicitem objectForKey:@"materialId"]];
                        NSDictionary *respDic = @{@"storageName":storageName,
                                                  @"materialId":materialId};
                        [materialIdArr addObject:respDic];
                        
                        if (materialIdArr.count == (tokensArr.count - weakSelf.uploadFileNumber)) {
                            [self geturlmaterialId:materialIdArr];
                        }
                    }
                } else {
                    weakSelf.uploadFileNumber ++;
                }
            } option:uploadOption];
        }
    }
    
    
    
    //    uploadOption.cancellationSignal();  // 取消的时候调用
}

-(void)geturlmaterialId:(NSMutableArray *)materialIdArr{

//    [HttpRequest requestUrlPath:get_materialURL parameters:@{@"resources":materialIdArr} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
//        if (status == 1) {
//            if (self.callBackEvent) {
//                NSArray * urlArr = dic[@"resources"];
//                NSString *blockMsg = _uploadFileNumber > 0 ? [NSString stringWithFormat:@"上传失败%ld张，请重试",(long)_uploadFileNumber] : @"";
//                self.callBackEvent(urlArr,blockMsg);
//            }
//        } else {
//            self.callBackEvent([NSArray array],@"上传失败，请重试");
//        }
//    }];
}

-(void)uploadSingleFileWithPath:(NSString *)filePath storageName:(NSString *)storageName uploadToken:(NSString *)uploadToken progress:(void (^) (double progress))progressBlock backData:(void(^)(NSDictionary *backDic,NSString *message))callBakcEvent
{
    self.progressHandle = progressBlock;
    
    if (IsStrEmpty(uploadToken) || IsStrEmpty(storageName) || IsStrEmpty(filePath)) {
        callBakcEvent([NSDictionary dictionary],@"上传失败，请重试");
        return;
    }
    
    NSString *pathStr = [NSTemporaryDirectory() stringByAppendingString:@"rmt_fengxian"];
    QNFileRecorder *fileRecorder = [QNFileRecorder fileRecorderWithFolder:pathStr error:nil];
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.useConcurrentResumeUpload = NO; // 默认为NO
        builder.concurrentTaskCount = 3; // 默认并行线程数为3
        builder.zone = [[QNFixedZone alloc]initWithupDomainList:@[@"up-qos.storage.shmedia.tech"]];
        builder.recorder = fileRecorder;
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    
    KWeakSelf
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        KStrongSelf(weakSelf)
        SAFE_BLOCK(strongSelf.progressHandle,percent);
    } params:nil checkCrc:NO cancellationSignal:^BOOL{
        return _cancelUpload;
    }];
    
    NSURL *pathUrl = [NSURL URLWithString:filePath];
    [upManager putFile:pathUrl.path key:storageName token:uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (!IsNilOrNull(resp)) {
            NSDictionary *dicitem = [resp objectForKey:@"data"];
            if ([dicitem.allKeys containsObject:@"materialId"]) {
                NSString *materialId = [NSString stringWithFormat:@"%@",[dicitem objectForKey:@"materialId"]];
                NSDictionary *respDic = @{@"mimeType":uploadOption.mimeType,
                                          @"materialId":materialId};
                callBakcEvent(respDic,@"上传成功");
            }
        } else {
            callBakcEvent([NSDictionary dictionary],@"上传失败，请重试");
        }
    } option:uploadOption];
}
@end
