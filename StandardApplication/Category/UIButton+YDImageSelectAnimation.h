//
//  UIButton+YDImageSelectAnimation.h
//  StandardApplication
//
//  Created by liyuanbo on 2020/8/4.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YDImageSelectAnimation)

- (void)yd_setSelected:(BOOL)selected
              animated:(BOOL)animated
            completion:(void (^) (BOOL finished))completion;

@end
