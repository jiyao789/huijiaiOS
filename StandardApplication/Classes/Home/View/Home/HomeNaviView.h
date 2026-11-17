//
//  HomeNaviView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeNaviView : UIView
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *noReadLab;
@property (weak, nonatomic) IBOutlet UIImageView *huijiaImageView;

@end

NS_ASSUME_NONNULL_END
