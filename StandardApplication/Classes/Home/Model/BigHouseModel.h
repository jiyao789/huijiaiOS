//
//  BigHouseModel.h
//  StandardApplication
//
//  Created by DTiOS on 2024/3/30.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface BigHouseModel : NSObject
@property (retain, nonatomic) NSString *house_id;
@property (retain, nonatomic) NSString *main_img;  // 封面图片
@property (assign, nonatomic) NSInteger bedroom_num; // 室数（几居室)
@property (strong, nonatomic) NSString *bedroom_num_string;
@property (assign, nonatomic) NSInteger parlor_num;   //  厅
@property (assign, nonatomic) NSInteger toilet_num;    //  卫生间
@property (assign, nonatomic) CGFloat price;    //  租金
@property (strong, nonatomic) NSString *priceString;
@property (assign, nonatomic) CGFloat total_area;    //  面积
@property (retain, nonatomic) NSString *neighborhood_name;   //  小区名称
@property (strong, nonatomic) NSString *neighborhood_address;   //  小区地址
@property (retain, nonatomic) NSString *orientation;   //  朝向
@property (retain, nonatomic) NSString *facilities;   //  设施
@property (strong, nonatomic) NSString *desc;  //  介绍
@property (assign, nonatomic) NSInteger elevator;    //  电梯（0：无，1:有）
@property (retain, nonatomic) NSString *pictures;
@property (strong, nonatomic) NSArray *picturesArr;
@property (retain, nonatomic) NSString *landlord_phone;
@property (retain, nonatomic) NSString *landlord_name;
@end

NS_ASSUME_NONNULL_END
