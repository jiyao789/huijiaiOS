//
//  SecondConfirmView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecondConfirmView : UIView

@property(nonatomic, copy) void (^didConfirmBlock) (void);
@property(nonatomic, copy) void (^didCancelBlock) (void);

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnLayoutX;

@end

NS_ASSUME_NONNULL_END
