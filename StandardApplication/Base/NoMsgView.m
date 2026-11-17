//
//  NoMsgView.m
//  CunQiuDPro
//
//  Created by liuyong on 15/11/2.
//  Copyright (c) 2015年 NDZIOS01. All rights reserved.
//

#import "NoMsgView.h"
#import "MacroDefine.h"

@implementation NoMsgView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    self.frame = CGRectMake(0, _originY > 0 ? _originY : 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
}

@end
