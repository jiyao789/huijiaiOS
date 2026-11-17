//
//  UIButton+YDImageSelectAnimation.m
//  StandardApplication
//
//  Created by liyuanbo on 2020/8/4.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import "UIButton+YDImageSelectAnimation.h"
#import "MacroDefine.h"

@implementation UIButton (YDImageSelectAnimation)

- (void)yd_setSelected:(BOOL)selected animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    self.selected = selected;
    self.userInteractionEnabled = NO;
    if (!animated) {
        self.userInteractionEnabled = YES;
        SAFE_BLOCK(completion,YES);
        return;
    }
    
    UIImage * beiginImage = [UIImage new];
    UIImage * endImage = [UIImage new];
    if (selected) {
        beiginImage = [self imageForState:UIControlStateNormal];
        endImage = [self imageForState:UIControlStateSelected];
    }else {
        beiginImage = [self imageForState:UIControlStateSelected];
        endImage = [self imageForState:UIControlStateNormal];
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.fromValue = (__bridge id _Nullable)(beiginImage.CGImage);
    animation.toValue = (__bridge id _Nullable)(endImage.CGImage);
    animation.duration = 0.32f;
    animation.removedOnCompletion = YES;
    
    @weakify(self)
    animation.qmui_animationDidStopBlock = ^(__kindof CAAnimation *aAnimation, BOOL finished) {
        @strongify(self)
        self.userInteractionEnabled = YES;
        SAFE_BLOCK(completion,finished);
    };
    
    [self.imageView.layer addAnimation:animation forKey:@"contentAnimation"];
}

@end
