//
//  ContractWarnView.h
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "MessageIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContractWarnView : UIView
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *continueContractBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *refundContractBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) MessageModel *messageModel;
@property (strong, nonatomic) UINavigationController *navigation;
@property (nonatomic, copy) void (^didCancelBlock) (void);
@end

NS_ASSUME_NONNULL_END
