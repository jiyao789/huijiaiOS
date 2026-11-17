//
//  UIImageView+ECExtension.m
//  StandardApplication
//
//  Created by chao on 2020/2/24.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "UIImageView+ECExtension.h"
#import "UIImageView+WebCache.h"
#import "CommonUtils.h"


@implementation UIImageView (ECExtension)


- (void)setImageUrl:(NSString *)url placeholderImage:(NSString *)imageName
{
    if ([url length] == 0) {
        self.image = [UIImage imageNamed:imageName];
    }
    if ([CommonUtils isHasChineseWithStr:url] || [url containsString:@">"] || [url containsString:@" "] || [url containsString:@"?"]) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName]  options:SDWebImageLowPriority|SDWebImageRetryFailed|SDWebImageScaleDownLargeImages];
}
@end
