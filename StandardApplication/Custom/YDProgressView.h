//
//  YDProgressView.h
//  StandardApplication
//
//  Created by liyuanbo on 2020/9/21.
//  Copyright © 2020 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YDProgressView : UIView

/**
 progress 0~1
 */
@property (nonatomic, assign) float progress;

@property(nonatomic, strong) UIColor* progressTintColor;
@property(nonatomic, strong) UIColor* trackTintColor;

@end

