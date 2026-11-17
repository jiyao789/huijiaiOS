//
//  MusicDownLoadManager.h
//  StandardApplication
//
//  Created by DTiOS on 2020/11/2.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "AFURLSessionManager.h"
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface MusicDownLoadManager : AFURLSessionManager

+ (instancetype)sharedManager;

- (void)downloadWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
