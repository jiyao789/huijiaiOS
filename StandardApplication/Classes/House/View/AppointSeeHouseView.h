//
//  AppointSeeHouseView.h
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppointSeeHouseView : UIView
@property (assign, nonatomic) NSInteger unit_id;
@property (nonatomic, copy) void (^didCancelBlock) (void);
@property (strong, nonatomic) NSMutableArray *phoneArr;
@property (assign, nonatomic) NSInteger houseClass;  // 房源分类
@end

NS_ASSUME_NONNULL_END
