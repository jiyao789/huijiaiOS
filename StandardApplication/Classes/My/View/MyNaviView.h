//
//  MyNaviView.h
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNaviView : UIView
@property (weak, nonatomic) IBOutlet QMUIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *noReadLab;
@end

NS_ASSUME_NONNULL_END
