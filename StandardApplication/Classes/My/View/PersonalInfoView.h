//
//  PersonalInfoView.h
//  smarthome
//
//  Created by DTiOS on 2021/8/18.
//  Copyright © 2021 Dev6. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalInfoView : UIView
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (copy, nonatomic) void (^personInfoCancelBlock) (void);
@property (copy, nonatomic) void (^personInfoCommitBlock) (void);
@end

NS_ASSUME_NONNULL_END
