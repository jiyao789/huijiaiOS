//
//  ChooseHouseRentView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseHouseRentView : UIView
@property (nonatomic, copy) void (^chooseHouseUnitShiViewBlock)(NSInteger shiKey,NSString *name);
@property (nonatomic, copy) void (^chooseHouseShiViewBlock)(NSString *shi);
@property (nonatomic, copy) void (^chooseHouseNatureViewBlock)(NSInteger nature);
@property (nonatomic, copy) void (^chooseHousePriceViewBlock)(NSString *price);
@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) NSArray *shiArr;
@property (strong, nonatomic) NSArray *natureArr;
@property (strong, nonatomic) NSDictionary *priceDic;
@property (strong, nonatomic) NSArray *unitArr;
@property (strong, nonatomic) NSMutableArray *selectShiArr;
@property (strong, nonatomic) NSMutableArray *selectShiKeyArr;
@property (strong, nonatomic) NSMutableArray *selectPriceArr;
@property (assign, nonatomic) NSInteger selectNatureIndex;
@end

NS_ASSUME_NONNULL_END
