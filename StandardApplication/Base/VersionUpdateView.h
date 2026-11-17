//
//  VersionUpdateView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/11/9.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface VersionUpdateView : UIView
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *versionInfoLab;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *forcedUpdateBtn;

@property (strong, nonatomic) NSDictionary *versionDic;

@property(nonatomic, copy) void (^didConfirmBlock) (void);
@property(nonatomic, copy) void (^didCancelBlock) (void);
@end

NS_ASSUME_NONNULL_END
