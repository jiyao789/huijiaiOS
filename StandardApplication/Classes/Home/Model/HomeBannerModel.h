//
//  HomeBannerModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/30.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBannerModel : NSObject
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *image_url;
@property (retain, nonatomic) NSString *link;


/// 专题相关
/// 0 特色 1 推文
@property (assign, nonatomic) NSInteger type;
@property (retain, nonatomic) NSString *img_url;
/// 推文ID 详情detail
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *point;
@end

NS_ASSUME_NONNULL_END
