//
//  PSBarButtonItem.m
//  PublicFundraising
//
//  Created by Apple on 15/10/9.
//  Copyright © 2015年 Niuduz. All rights reserved.
//

#import "PSBarButtonItem.h"
#import "MacroDefine.h"

@implementation PSBarButtonItem
+ (instancetype)itemWithTitle:(NSString *)title
                        barStyle:(PSNavItemStyle)style
                       target:(id)target
                       action:(SEL)action leftOrRight:(BOOL)isLeft
{
    
    if (style == PSNavItemStyleLeft)
    {
        //返回
        QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:@"black_pop_img.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"black_pop_img.png"] forState:UIControlStateHighlighted];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#0D2E53"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        btn.frame = CGRectMake(0, 0, 60, 30);
        btn.imagePosition = QMUIButtonImagePositionTop;
        btn.spacingBetweenImageAndTitle = 2;
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        PSBarButtonItem *item = [[PSBarButtonItem alloc] initWithCustomView:btn];
        return item;
    }
    else if (style == PSNavItemStyleMainDone)
    {
        QMUIButton *btn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#2A629A"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        CGSize poinsSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedSize:CGSizeMake(MAXFLOAT, 40)];
        btn.frame = CGRectMake(0, 0, poinsSize.width + 30, 40);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        PSBarButtonItem *item = [[PSBarButtonItem alloc] initWithCustomView:btn];
        return item;
    }
    else if (style == PSNavItemStyleBlackDone)
    {
        PSBarButtonItem *item = [[PSBarButtonItem alloc]
                                 initWithTitle:title
                                 style:UIBarButtonItemStylePlain
                                 target:target
                                 action:action];
        if (isLeft) {
            [item setTitlePositionAdjustment:UIOffsetMake(10, 0) forBarMetrics:UIBarMetricsDefault];
        } else {
            [item setTitlePositionAdjustment:UIOffsetMake(-15, 0) forBarMetrics:UIBarMetricsDefault];
        }
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        item.tintColor = [UIColor colorWithHexString:@"#333333"];
        return item;
    }
    else
    {
        return nil;
    }
}

+ (instancetype)itemRightWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
        
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    UIImage *normalImage;
    if (normalImageName)
    {
        normalImage = [UIImage imageNamed:normalImageName]; 
        [btn setImage:normalImage forState:UIControlStateNormal];
    }
    
    if (highImageName)
    {
        [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    }
    
    if (selectedImageName)
    {
        [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectMake(0, 0, 52, 44);
    btn.frame = rect;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    PSBarButtonItem *item = [[PSBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (instancetype)itemLeftWithImageName:(NSString *)normalImageName highLightImageName:(NSString *)highImageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    UIImage *normalImage;
    if (normalImageName)
    {
        normalImage = [UIImage imageNamed:normalImageName];
        [btn setImage:normalImage forState:UIControlStateNormal];
    }
    
    if (highImageName)
    {
        [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    }
    
    if (selectedImageName)
    {
        [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = CGRectMake(0, 0, 44, 44);
    btn.frame = rect;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    PSBarButtonItem *item = [[PSBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if ([self.customView isKindOfClass:[UIControl class]])
    {
        UIControl *ctrl = (UIControl *)self.customView;
        ctrl.enabled = enabled;
    }
}
@end
