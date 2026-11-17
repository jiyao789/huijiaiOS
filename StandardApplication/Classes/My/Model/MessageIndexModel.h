//
//  MessageIndexModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/2.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"
#import "WorkOrderIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger other_id;
///1 推送消息 2 活动消息 3 缴费消息 4 合同消息
@property (assign, nonatomic) NSInteger message_type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDictionary *content;
///1 未读 2 已读 3 删除 0 未生效
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *created_time;
@property (assign, nonatomic) NSInteger contract_status;
@property (strong, nonatomic) NSString *contract_viewpdf_url;
@property (strong, nonatomic) NSString *contract_number;
@property (strong, nonatomic) NSString *contract_end_date;

@end

@interface MessageIndexModel : NSObject
@property (strong, nonatomic) NSArray *system_message;
@property (strong, nonatomic) NSArray *pay_message;
@property (strong, nonatomic) NSArray *contract_message;
@property (strong, nonatomic) NSArray *internal_message;
@property (strong, nonatomic) WorkOrderIndexModel *work_order;
@property (assign, nonatomic) NSInteger mark;
@property (strong, nonatomic) NSString *content_mark;

@property (assign, nonatomic) BOOL isSystem;
@property (assign, nonatomic) BOOL isWorkOrder;
@property (assign, nonatomic) BOOL isPay;
@property (assign, nonatomic) BOOL isContract;
@property (assign, nonatomic) BOOL isPush;

@end

NS_ASSUME_NONNULL_END
