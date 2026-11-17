//
//  ActivityDetailBottomView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/4.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityDetailBottomView : UIView
@property (strong, nonatomic) ActivityListModel *activityListModel;
@property (strong, nonatomic) UINavigationController *navigation;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@end

NS_ASSUME_NONNULL_END
