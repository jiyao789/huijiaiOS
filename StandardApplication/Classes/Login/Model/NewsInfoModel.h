//
//  NewsInfoModel.h
//  StandardApplication
//
//  Created by DTiOS on 2022/8/5.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsInfoModel : NSObject

@property (assign, nonatomic) NSInteger new_id;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *file_url;
@property (retain, nonatomic) NSString *created_time;
@property (retain, nonatomic) NSString *image_url;

@property (assign, nonatomic) CGFloat rowHeight;
@end

NS_ASSUME_NONNULL_END
