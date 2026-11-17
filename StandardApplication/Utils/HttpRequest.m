//
//  HttpRequest.m
//  StandardApplication
//
//  Created by chao on 2019/8/9.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "HttpRequest.h"
#import <MJExtension/MJExtension.h>
#import "User.h"
#import "ECUUIDTool.h"
#import "IOSmd5.h"
#import <SDWebImage/SDWebImage.h>

@interface HttpRequest ()

@property (nonatomic, strong) NSDictionary * headerDic;

@property (assign, nonatomic) AFNetworkReachabilityStatus networkStatus;

@end

@implementation HttpRequest

+ (instancetype)shareInstance
{
    static HttpRequest *_httpRequest = nil;
    static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       _httpRequest = [[super allocWithZone:NULL] init];
   });
   return _httpRequest;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}
- (void)startMonitoring {
    
    AFNetworkReachabilityManager *man = [AFNetworkReachabilityManager sharedManager];
    //开始监听
    [man startMonitoring];
    [man setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.networkStatus = status;
        switch (status) {
                
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"网络错误");
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有连接网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
        }
    }];
}

- (NSString *)netStatus
{
    //网络环境：2g，3g，4g，wifi
    switch (self.networkStatus) {
        case AFNetworkReachabilityStatusUnknown:
            return @"unknow";
        case AFNetworkReachabilityStatusNotReachable:
            return @"notReachable";
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"4g";
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"wifi";
        default:
            break;
    }
}
+ (NSString *)baseUrl
{
    return BaseURL;
}
+ (void)requestUrlPath:(NSString *)serverId
               urlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters type:(HttpRequestType)type result:(void (^)(NSDictionary *dic,NSInteger status,NSString *msg))result
{
    [self requestBaseURL:serverId urlPath:urlPath parameters:parameters isNeedNet:YES type:type result:result];
}

+ (void)requestArrUrlPath:(NSString *)serverId
                  urlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters type:(HttpRequestType)type result:(void (^)(NSArray *arr,NSInteger status,NSString *msg))result
{
    [self requestBaseURL:serverId urlPath:urlPath parameters:parameters isNeedNet:YES type:type result:result];
}

+ (void)cacheResponseObject:(NSString *)serverId
                  urlPath:(NSString *)urlPath parameters:(NSDictionary *)parameters isNeedNet:(BOOL)isNeed type:(HttpRequestType)type result:(void (^)(id objs,NSInteger status,NSString *msg))result
{
    [self requestBaseURL:serverId urlPath:urlPath parameters:parameters isNeedNet:isNeed type:type result:result];
}

+ (void)requestBaseURL:(NSString *)serverId
   urlPath:(NSString *)userPath
parameters:(NSDictionary *_Nullable)parameters
    isNeedNet:(BOOL)isNeed
      type:(HttpRequestType)type
   result:(void (^)(id objs,NSInteger status,NSString *msg))result
{
    NSString * urlPath = [NSString stringWithFormat:@"%@%@",serverId,userPath];
    
    NSDictionary *parma = [self parameterDicWithDic:parameters];
    
    NSLog(@"🔵🔵🔵 TOKEN: %@",[User shareUser].token);
    NSLog(@"🔵🔵🔵 REQUEST: %@ ===== %@",urlPath,parma);
    printf("\n🔵🔵🔵 REQUEST: %s ===== %s\n", [urlPath UTF8String], [[parma description] UTF8String]);
    
    if (!isNeed) {
        if ([userPath isEqualToString:lock_device_listingURL] || [userPath isEqualToString:lock_device_infoURL] || [userPath isEqualToString:lock_key_search_keyURL]) {
            NSDictionary *cacheResponseDic = [BaseNetworkCache cacheJsonWithURL:[urlPath stringByAppendingString:[NSString convertToJsonData:[self parameterCacheDicWithDic:parameters]]]];
            if (!IsNilOrNull(cacheResponseDic)) {
                [self manageReturnObject:cacheResponseDic result:result];
                return;
            }
        }
    }
    
    AFHTTPSessionManager *manager = [[self class] getSessionManager];
    switch (type) {
        case HttpRequestTypeGet:
        {
            [manager GET:urlPath parameters:parma headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"🟢🟢🟢 RESPONSE: %@ ====== %@",urlPath,responseDic);
                printf("\n🟢🟢🟢 RESPONSE: %s ====== %s\n", [urlPath UTF8String], [[responseDic description] UTF8String]);

                
                NSInteger stateCode = [[responseDic valueForKey:@"code"] integerValue];
                
                // 缓存  开锁列表、获取开锁设备id、获取锁详情、上传开锁记录
                if ([userPath isEqualToString:lock_device_listingURL] || [userPath isEqualToString:lock_device_infoURL] || [userPath isEqualToString:lock_key_search_keyURL]) {
                    if (stateCode == 200) {
                        [BaseNetworkCache saveJsonResponseToCacheFile:responseDic andURL:[urlPath stringByAppendingString:[NSString convertToJsonData:[self parameterCacheDicWithDic:parameters]]]];
                    } else {
                        [self cacheResponseObject:urlPath para:[self parameterCacheDicWithDic:parameters] result:result];
                        return;
                    }
                }
                
                [self manageReturnObject:responseDic result:result];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self cacheResponseObject:urlPath para:[self parameterCacheDicWithDic:parameters] result:result];
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [manager POST:urlPath parameters:parma headers:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"🟢🟢🟢 RESPONSE: %@ ====== %@",urlPath,responseDic);
                printf("\n🟢🟢🟢 RESPONSE: %s ====== %s\n", [urlPath UTF8String], [[responseDic description] UTF8String]);
                NSInteger stateCode = [[responseDic valueForKey:@"code"] integerValue];
                
                // 缓存  开锁列表、获取开锁设备id、获取锁详情、上传开锁记录
                if ([userPath isEqualToString:lock_device_listingURL] || [userPath isEqualToString:lock_device_infoURL] || [userPath isEqualToString:lock_key_search_keyURL]) {
                    if (stateCode == 200) {
                        [BaseNetworkCache saveJsonResponseToCacheFile:responseDic andURL:[urlPath stringByAppendingString:[NSString convertToJsonData:[self parameterCacheDicWithDic:parameters]]]];
                    } else {
                        [self cacheResponseObject:urlPath para:[self parameterCacheDicWithDic:parameters] result:result];
                        return;
                    }
                }
                
                [self manageReturnObject:responseDic result:result];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self cacheResponseObject:urlPath para:[self parameterCacheDicWithDic:parameters] result:result];
            }];
        }
            break;
    }
}

+ (void)manageReturnObject:(NSDictionary *)responseDic result:(void (^)(id objs,NSInteger status,NSString *msg))result
{
    NSString * resultMsg = [responseDic valueForKey:@"msg"];
    NSInteger stateCode = [[responseDic valueForKey:@"code"] integerValue];
    id resultObjt = [responseDic valueForKey:@"data"];
    
    if (stateCode == 200) {
        if ([resultObjt isKindOfClass:[NSArray class]]) {
            NSArray *resultArr = (NSArray *)resultObjt;
            if (resultArr.count == 0) {
                //2 成功  data无数据，例如提交表单
                result(resultObjt,2,resultMsg);
            } else if (!IsNilOrNull(resultObjt)) {
                //1 成功  data有数据
                result(resultObjt,1,resultMsg);
            }
        } else {
            if (IsNilOrNull(resultObjt)) {
                //2 成功  data无数据，例如提交表单
                result(nil,2,resultMsg);
            } else if (!IsNilOrNull(resultObjt)) {
                //1 成功  data有数据
                result(resultObjt,1,resultMsg);
            }
        }
    } else if (stateCode == 302) {
        // 账号被顶下来
        [[User shareUser] removeToken];
        [[User shareUser] removeMobile];
        [[User shareUser] removeUserId];
        [[User shareUser] removeApp_key];
        result(nil,-1,resultMsg);
    } else if (stateCode == 403) {
        result(nil,403,resultMsg);
    } else if (stateCode == 400) {
        result(nil,400,resultMsg);
    } else {
        result(nil,-1,resultMsg);
    }
}

+ (void)cacheResponseObject:(NSString *)urlPath para:(NSDictionary *)parameters result:(void (^)(id objs,NSInteger status,NSString *msg))result
{
    NSDictionary *cacheResponseDic = [BaseNetworkCache cacheJsonWithURL:[urlPath stringByAppendingString:[NSString convertToJsonData:parameters]]];
    if (!IsNilOrNull(cacheResponseDic)) {
        [self manageReturnObject:cacheResponseDic result:result];
        return;
    }
    result(nil,-1,@"网络繁忙，请稍候");
}

+ (void)requestNewsInfoData:(NSString *)type result:(void (^)(NewsInfoModel *model,NSString *msg))result
{
    [self requestUrlPath:ReleaseBaseURL urlPath:news_get_infoURL parameters:@{@"type":NONullString(type)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            NewsInfoModel *model = [NewsInfoModel mj_objectWithKeyValues:dic];
            result(model,msg);
        } else {
            result(nil,msg);
        }
    }];
}

+ (AFHTTPSessionManager *)getSessionManager
{
    static AFHTTPSessionManager *manager=nil;
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{

        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];  // 使用HTTP序列化器，不是JSON
//        [manager.requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"charset"];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer.timeoutInterval = 20.0f;
//        [manager.requestSerializer setQueryStringSerializationWithStyle:AFHTTPRequestQueryStringDefaultStyle];

        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    });
    return manager;
}

+ (void)uploadFileName:(NSDictionary *)parameters data:(id)fileData progress:(void (^) (double progress))progressBlock complete:(void (^) (NSDictionary *dic))completeBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60.0f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *pathUrl = [NSString stringWithFormat:@"%@%@",BaseURL,upload_indexURL];
    [manager POST:pathUrl parameters:[self parameterDicWithDic:parameters] headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSString *mineType;
        if ([fileData isKindOfClass:[UIImage class]])
        {
            NSString *fileName = [NSString stringWithFormat:@"%@.png",[NSDate getNowDateStr]];

            NSData *imageData = UIImageJPEGRepresentation((UIImage *)fileData, 0.5);
            mineType = @"image/png";
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:mineType];
        }else
        {
            NSString *fileName = [NSString stringWithFormat:@"%@.mp4",[NSDate getNowDateStr]];
            mineType = @"amr/audio/mp4/wav/mp3";
            [formData appendPartWithFileURL:(NSURL *)fileData name:@"file" fileName:fileName mimeType:mineType error:nil];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        double progress = (double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount;
        progressBlock(progress);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (dic.allKeys.count > 0 && [[dic objectForKey:@"code"] integerValue] == 200) {
            completeBlock([dic valueForKey:@"data"]);
        } else if ([[dic objectForKey:@"code"] integerValue] == 302) {
            // 账号被顶下来
            [[User shareUser] removeToken];
            [[User shareUser] removeMobile];
            [[User shareUser] removeUserId];
            [[User shareUser] removeApp_key];
            [MBProgressHUD showMessag:NONullString(dic[@"msg"]) toView:kAppWindow];
            completeBlock(nil);
        } else {
            [MBProgressHUD showMessag:NONullString(dic[@"msg"]) toView:kAppWindow];
            completeBlock(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showMessag:@"上传失败" toView:kAppWindow];
        completeBlock(nil);
    }];
}

+ (void)uploadFileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(double progress))progressBlock complete:(void (^)(NSDictionary *dic))completeBlock
{
    if (!data || data.length == 0) {
        completeBlock(nil);
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120.0f; // Longer timeout for larger files
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *pathUrl = [NSString stringWithFormat:@"%@%@", BaseURL, upload_indexURL];

    // Generate unique filename if not provided
    if (fileName.length == 0) {
        fileName = [NSString stringWithFormat:@"%@.pdf", [NSDate getNowDateStr]];
    }

    // Default MIME type for PDF
    if (mimeType.length == 0) {
        mimeType = @"application/pdf";
    }

    [manager POST:pathUrl parameters:[self parameterDicWithDic:@{@"key":@"header"}] headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        double progress = (double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount;
        if (progressBlock) {
            progressBlock(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (dic.allKeys.count > 0 && [[dic objectForKey:@"code"] integerValue] == 200) {
            completeBlock([dic valueForKey:@"data"]);
        } else if ([[dic objectForKey:@"code"] integerValue] == 302) {
            // Session expired
            [[User shareUser] removeToken];
            [[User shareUser] removeMobile];
            [[User shareUser] removeUserId];
            [[User shareUser] removeApp_key];
            [MBProgressHUD showMessag:NONullString(dic[@"msg"]) toView:kAppWindow];
            completeBlock(nil);
        } else {
            [MBProgressHUD showMessag:NONullString(dic[@"msg"]) toView:kAppWindow];
            completeBlock(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showMessag:@"上传失败" toView:kAppWindow];
        completeBlock(nil);
    }];
}

+ (void)uploadPDFData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)mimeType progress:(void (^)(double progress))progressBlock complete:(void (^)(NSDictionary *dic))completeBlock
{
    if (!data || data.length == 0) {
        completeBlock(nil);
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 120.0f;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    // Use BaseURL + upload_fileURL (same format as upload_indexURL)
    NSString *pathUrl = [NSString stringWithFormat:@"%@%@", BaseURL, upload_fileURL];

    // Generate unique filename if not provided
    if (fileName.length == 0) {
        fileName = [NSString stringWithFormat:@"%@.pdf", [NSDate getNowDateStr]];
    }

    // Default MIME type for PDF
    if (mimeType.length == 0) {
        mimeType = @"application/pdf";
    }

    [manager POST:pathUrl parameters:[self parameterDicWithDic:@{@"key":@"header"}] headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        double progress = (double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount;
        if (progressBlock) {
            progressBlock(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (dic.allKeys.count > 0 && [[dic objectForKey:@"code"] integerValue] == 200) {
            completeBlock([dic valueForKey:@"data"]);
        } else if ([[dic objectForKey:@"code"] integerValue] == 302) {
            // Session expired
            [[User shareUser] removeToken];
            [[User shareUser] removeMobile];
            [[User shareUser] removeUserId];
            [[User shareUser] removeApp_key];
            [MBProgressHUD showMessag:NONullString(dic[@"msg"]) toView:kAppWindow];
            completeBlock(nil);
        } else {
            [MBProgressHUD showMessag:NONullString(dic[@"msg"]) toView:kAppWindow];
            completeBlock(nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showMessag:@"上传失败" toView:kAppWindow];
        completeBlock(nil);
    }];
}

+ (NSDictionary *)parameterDicWithDic:(NSDictionary *)pamar
{
    // 对传的参数进行处理
    NSMutableDictionary * dic = pamar?[NSMutableDictionary dictionaryWithDictionary:pamar]:[NSMutableDictionary dictionary];
    [dic setObject:[NSDate getNowDate1970Str] forKey:@"stime"];
    if ([User shareUser].token.length) {
        [dic setObject:[User shareUser].token forKey:@"token"];
    }
    [dic setObject:[self sortedDictionary:dic] forKey:@"sign"];
    return dic;
}

+ (NSDictionary *)parameterCacheDicWithDic:(NSDictionary *)pamar
{
    // 对传的参数进行处理
    NSMutableDictionary * dic = pamar?[NSMutableDictionary dictionaryWithDictionary:pamar]:[NSMutableDictionary dictionary];
//    if ([User shareUser].token.length) {
//        [dic setObject:[User shareUser].token forKey:@"token"];
//    }
    return dic;
}

+ (NSString *)sortedDictionary:(NSDictionary *)dict {
    NSMutableString *contentString = [NSMutableString string];
    NSArray *keys  = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *keyStr in sortedArray) {
        NSString *valueStr = [NSString stringWithFormat:@"%@",[dict objectForKey:keyStr]];
        if (![valueStr isEqualToString:@""] || ![valueStr isEqualToString:@"key"] ) {
            [contentString appendFormat:@"%@=%@&",keyStr,valueStr];
        }
    }
    contentString  = (NSMutableString *)[contentString substringToIndex:contentString.length - 1];
    NSString *signStr = [IOSmd5 md5:contentString];
    return signStr;
}


@end
