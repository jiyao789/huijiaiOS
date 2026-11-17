//
//  OwnerViewController.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "BaseViewController.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OwnerViewController : BaseViewController<JXCategoryListContentViewDelegate>
@property (strong, nonatomic) UINavigationController *naviController;

@end

NS_ASSUME_NONNULL_END
