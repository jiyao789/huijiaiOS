//
//  BaseNetworkCache.h
//  StandardApplication
//
//  Created by DTiOS on 2020/3/4.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNetworkCache : NSObject

/// 手动写入/更新缓存
+(BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL;



/// 获取缓存的对象
+(id )cacheJsonWithURL:(NSString *)URL;


@end

NS_ASSUME_NONNULL_END
