//
//  SearchNaviView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchNaviView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet QMUIButton *searchBackBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet BaseShadowView *searchView;

@property (nonatomic, copy) void (^searchNaviButtonBlock)(NSString *text);
@property (nonatomic, copy) void (^searchNaviTextFieldBlock)(void);
@end

NS_ASSUME_NONNULL_END
