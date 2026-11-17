//
//  AgreementUpdateAlertView.h
//  StandardApplication
//
//  Created on 2026/11/17.
//  Copyright © 2026 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AgreementUpdateAlertView : UIView

@property (nonatomic, copy) void (^confirmBlock)(void);
@property (nonatomic, copy) void (^privacyClickBlock)(void);
@property (nonatomic, copy) void (^userAgreementClickBlock)(void);

+ (instancetype)alertView;

@end

NS_ASSUME_NONNULL_END
