//
//  UploadFileManager.h
//  StandardApplication
//
//  Created by DTiOS on 2020/8/3.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadFileManager : NSObject

+(UploadFileManager *)shareManager;

@property (nonatomic, copy) void(^callBackEvent)(NSArray *urlArr,NSString *message);

// 取消上传
@property (nonatomic, assign) BOOL cancelUpload;

//上传进度
@property (nonatomic, copy) void (^progressHandle) (double);


-(void)uploadData:(NSArray *)nameArr upFile:(NSArray *)file progress:(void (^) (double progress))progressBlock backData:(void(^)(NSArray *urlArr,NSString *message))callBackEvent;


//H5桥接
-(void)uploadSingleFileWithPath:(NSString *)filePath storageName:(NSString *)storageName uploadToken:(NSString *)uploadToken progress:(void (^) (double progress))progressBlock backData:(void(^)(NSDictionary *backDic,NSString *message))callBakcEvent;
@end

NS_ASSUME_NONNULL_END
