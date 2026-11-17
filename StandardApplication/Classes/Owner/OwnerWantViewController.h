//
//  OwnerWantViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OwnerWantViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property (strong, nonatomic) UINavigationController *naviController;

@end

NS_ASSUME_NONNULL_END
