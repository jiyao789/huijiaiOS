//
//  WorkOrderDetailModel.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/3.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderDetailModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger work_id;
@property (strong, nonatomic) NSString *msg;
/// 1 APP 2 B端
@property (assign, nonatomic) NSInteger commit_client;
/// 用户名
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *images;
@property (strong, nonatomic) NSString *img_url;
@property (strong, nonatomic) NSArray *imageArr;
@end

NS_ASSUME_NONNULL_END
