//
//  MyAppointSeeViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAppointSeeViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property (strong, nonatomic) UINavigationController *naviController;
@property (assign, nonatomic) NSInteger type;  // 0 预约 1 预定
@end

NS_ASSUME_NONNULL_END
