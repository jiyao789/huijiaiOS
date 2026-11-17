//
//  HouseSearchNaviView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseSearchNaviView : UIView
@property (weak, nonatomic) IBOutlet UILabel *searchTitleLab;
@property (weak, nonatomic) IBOutlet QMUIButton *houseBackBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *messageBtn;
@property (weak, nonatomic) IBOutlet BaseShadowView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewLayoutLeft;
@property (weak, nonatomic) IBOutlet UILabel *noReadLab;

@property (assign, nonatomic) NSInteger nature;
@end

NS_ASSUME_NONNULL_END
