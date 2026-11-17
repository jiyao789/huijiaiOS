//
//  LifeMyNaviView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface LifeMyNaviView : UIView
@property (weak, nonatomic) IBOutlet QMUIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *noReadLab;

@end

NS_ASSUME_NONNULL_END
