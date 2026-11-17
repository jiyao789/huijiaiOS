//
//  ActivityListModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/1.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityListModel : NSObject
@property (assign, nonatomic) NSInteger act_id;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *briefly;
@property (retain, nonatomic) NSString *cover;
@property (retain, nonatomic) NSString *image_url;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *start_time;
@property (retain, nonatomic) NSString *end_time;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *link;
/// 0 关闭 1 可预约 2 进行中 3 已结束
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@end

NS_ASSUME_NONNULL_END
