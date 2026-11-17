//
//  HttpRequest.h
//  StandardApplication
//
//  Created by chao on 2019/8/9.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"
#import "AFNetworking.h"
#import "YDInterfaceDefinition.h"
#import "BaseNetworkCache.h"
#import "NewsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  网络请求类型
 */
typedef NS_ENUM(NSUInteger,HttpRequestType) {
    /**
     *  get请求
     */
    HttpRequestTypeGet = 0,
    /**
     *  post请求
     */
    HttpRequestTypePost
};

@interface HttpRequest : NSObject

@property (copy, readonly,nonatomic) NSString *netStatus;

//全局的返回的header数据
@property (nonatomic, strong, readonly) NSDictionary * headerDic;

+ (instancetype)shareInstance;

+ (NSString *)baseUrl;

+ (void)requestUrlPath:(NSString *)serverId
               urlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters type:(HttpRequestType)type result:(void (^)(NSDictionary *dic,NSInteger status,NSString *msg))result;
+ (void)requestArrUrlPath:(NSString *)serverId
                  urlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters type:(HttpRequestType)type result:(void (^)(NSArray *arr,NSInteger status,NSString *msg))result;

+ (void)cacheResponseObject:(NSString *)serverId
                  urlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters isNeedNet:(BOOL)isNeed type:(HttpRequestType)type result:(void (^)(id objs,NSInteger status,NSString *msg))result;

+ (void)uploadFileName:(NSDictionary *)parameters data:(id)fileData progress:(void (^) (double progress))progressBlock complete:(void (^) (NSDictionary *dic))completeBlock;

/// Upload file data (NSData) with specified filename and MIME type
/// @param data The file data to upload
/// @param fileName The filename including extension (e.g., "document.pdf")
/// @param mimeType The MIME type (e.g., "application/pdf")
/// @param progressBlock Upload progress callback
/// @param completeBlock Completion callback with response dictionary
+ (void)uploadFileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(double progress))progressBlock complete:(void (^)(NSDictionary *dic))completeBlock;

/// Upload PDF file using /upload/file endpoint
/// @param data The file data to upload
/// @param fileName The filename including extension (e.g., "document.pdf")
/// @param mimeType The MIME type (e.g., "application/pdf")
/// @param progressBlock Upload progress callback
/// @param completeBlock Completion callback with response dictionary containing "url" key
+ (void)uploadPDFData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(double progress))progressBlock complete:(void (^)(NSDictionary *dic))completeBlock;

+ (void)requestNewsInfoData:(NSString *)type result:(void (^)(NewsInfoModel *model,NSString *msg))result;

@end

NS_ASSUME_NONNULL_END
