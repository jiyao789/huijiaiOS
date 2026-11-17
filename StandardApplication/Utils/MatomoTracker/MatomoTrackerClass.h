//
//  MatomoTrackerClass.h
//  EnjoyOilBao
//
//  Created by DTiOS on 2019/3/12.
//  Copyright © 2019 yiye. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MatomoTracker;
NS_ASSUME_NONNULL_BEGIN

@interface MatomoTrackerClass : NSObject
@property (strong, nonatomic) MatomoTracker *matomoTracker;
///获取使用实例
+ (instancetype)sharedMatomoTrackerClass;

- (MatomoTracker *)setMatomoTrackerInfo:(NSString *)siteId bunderId:(NSString *)bunderId;
@end

NS_ASSUME_NONNULL_END
