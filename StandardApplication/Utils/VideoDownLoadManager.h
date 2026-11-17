//
//  VideoDownLoadManager.h
//  StandardApplication
//
//  Created by liyuanbo on 2019/11/22.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDownLoadManager : AFURLSessionManager

+ (instancetype)sharedManager;

/**
 下载视频并保存至相册
 */
- (void)downloadWithUrl:(NSString *)url;

/**
 下载视频
 */
- (void)downloadVideoWithURL:(NSString *)url
                    progress:(void (^) (double progress))progressHandle
                   completed:(void(^)(NSString *urlPath))completedHandle;


+ (NSString *)launchAdVideoPath;

@end

NS_ASSUME_NONNULL_END
