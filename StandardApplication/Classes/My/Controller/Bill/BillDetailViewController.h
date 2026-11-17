//
//  BillDetailViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "HouseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BillDetailViewController : BaseViewController
//@property (strong, nonatomic) NSString *type;  // bill 账户中心的账单详情   apply 房源预定的账单详情

#pragma mark 预定相关
@property (assign, nonatomic) NSInteger bookId; // 预定id
@property (strong, nonatomic) HouseDetailModel *houseDetailModel;
@property (assign, nonatomic) CGFloat reserveAmount;

#pragma mark 账单相关
@property (assign, nonatomic) NSInteger b_id;
@end

NS_ASSUME_NONNULL_END
