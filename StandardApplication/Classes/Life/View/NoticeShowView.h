//
//  NoticeShowView.h
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShowView : UIView
@property (weak, nonatomic) IBOutlet UILabel *noticeLab;
@property (nonatomic, copy) void (^didCancelBlock) (void);
@end

NS_ASSUME_NONNULL_END
