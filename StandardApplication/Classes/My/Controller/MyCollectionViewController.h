//
//  MyCollectionViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionViewController : BaseViewController
@property (assign, nonatomic) NSInteger type; // 1 收藏 2 足迹 3 特色专题房源

@property (strong, nonatomic) NSString *point;  // type=3 时的特色标签
@end

NS_ASSUME_NONNULL_END
