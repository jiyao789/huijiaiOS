//
//  UIImageView+ECExtension.h
//  StandardApplication
//
//  Created by chao on 2020/2/24.
//  Copyright © 2020 DTiOS. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ECExtension)

- (void)setImageUrl:(NSString *)url placeholderImage:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
