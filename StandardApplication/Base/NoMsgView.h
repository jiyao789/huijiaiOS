//
//  NoMsgView.h
//  CunQiuDPro
//
//  Created by liuyong on 15/11/2.
//  Copyright (c) 2015年 NDZIOS01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoMsgView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *noMsgImageView;
@property (weak, nonatomic) IBOutlet UILabel *noMsgLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noMsgImageViewLayoutH;

@property (assign, nonatomic)CGFloat viewY;
@property (assign, nonatomic)CGFloat originY;
@end
