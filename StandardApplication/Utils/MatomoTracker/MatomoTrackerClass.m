//
//  MatomoTrackerClass.m
//  EnjoyOilBao
//
//  Created by DTiOS on 2019/3/12.
//  Copyright © 2019 yiye. All rights reserved.
//

#import "MatomoTrackerClass.h"


static MatomoTrackerClass *matomoTrackerClass = nil;

@implementation MatomoTrackerClass

//创建单例
+ (instancetype)sharedMatomoTrackerClass{
    if (nil == matomoTrackerClass) {
        matomoTrackerClass = [[MatomoTrackerClass alloc]init];
    }
    return matomoTrackerClass;
}


- (MatomoTracker *)setMatomoTrackerInfo:(NSString *)siteId bunderId:(NSString *)bunderId
{
    if (!_matomoTracker) {
        _matomoTracker = [[MatomoTracker alloc] initWithSiteId:siteId baseURL:[NSURL URLWithString:@"https://gl.ewdcloud.com/traffic.php"] userAgent:nil];
//        [[MatomoTracker alloc] initWithSiteId:siteId bunderId:bunderId baseURL:[NSURL URLWithString:@"https://gl.ewdcloud.com/traffic.php"] userAgent:nil];
    }
//initWithSiteId:siteId baseURL:[NSURL URLWithString:@"https://gl.ewdcloud.com/traffic.php"] userAgent:nil
//    方法
//    [_matomoTracker trackWithView:@[@"trackPageView"] url:nil];
//    [_matomoTracker trackWithEventWithCategory:@"category" action:@"action" name:nil number:nil url:nil];
//    [_matomoTracker trackSearchWithQuery:@"custom search string" category:@"custom search category" resultCount:15 url:nil];
//    [_matomoTracker dispatch];
//    _matomoTracker.logger = [[DefaultLogger alloc] initWithMinLevel:LogLevelVerbose];
//    [_matomoTracker trackCampaignWithName:@"campaign_name" keyword:@"campaign_keyword"];
//    [_matomoTracker trackContentImpressionWithName:@"" piece:@"" target:@""];
//    _matomoTracker.userId = @"Just a custom id";
    return _matomoTracker;
}

@end
