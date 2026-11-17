//
//  MBProgressHUD+YBDownload.h
//  StandardApplication
//
//  Created by liyuanbo on 2019/11/22.
//  Copyright © 2019 DTiOS. All rights reserved.
//


#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (YBDownload)

+ (MBProgressHUD *)showDownloadHudAddTo:(UIView *)view animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
