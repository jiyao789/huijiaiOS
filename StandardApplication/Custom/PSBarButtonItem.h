//
//  PSBarButtonItem.h
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSBarButtonItem : UIBarButtonItem

typedef NS_ENUM(NSInteger, PSNavItemStyle) {
    
    PSNavItemStyleLeft,
    PSNavItemStyleMainDone,
    PSNavItemStyleBlackDone
};

+ (instancetype)itemWithTitle:(NSString *)title
                        barStyle:(PSNavItemStyle)style
                       target:(id)target
                       action:(SEL)action leftOrRight:(BOOL)isLeft;
+ (instancetype)itemRightWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;

+ (instancetype)itemLeftWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;

@end
