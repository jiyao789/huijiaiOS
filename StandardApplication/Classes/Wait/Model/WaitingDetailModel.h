//
//  WaitingDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2023/6/18.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitingDetailModel : NSObject
@property (assign, nonatomic) NSInteger wait_id;
@property (assign, nonatomic) NSInteger u_id;
/// 轮候编号
@property (retain, nonatomic) NSString *number;
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *admission_number;
@property (retain, nonatomic) NSString *effective_date;
@property (assign, nonatomic) NSInteger unit_id;
/// 0:默认 1:轮候排队 2:轮候选房 3:已匹配 4:已签约 9:已取消
@property (assign, nonatomic) NSInteger status;
/// 0:正常 1:表示已取消
@property (assign, nonatomic) NSInteger canceled;
/// 0:默认 1:匹配成功 2:匹配失败
@property (assign, nonatomic) NSInteger allocated;
/// 0:默认 1:匹配成功 2:匹配失败
@property (assign, nonatomic) NSInteger collect;
/// 匹配时间
@property (retain, nonatomic) NSString *allocate_time;
@property (retain, nonatomic) NSString *notes;
@property (retain, nonatomic) NSString *created_time;
@property (strong, nonatomic) HouseListModel *unitInfo;
@end

NS_ASSUME_NONNULL_END
