//
//  ChooseLocationView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseLocationView : UIView
@property (nonatomic, copy) void (^chooseLocationViewBlock)(NSString *county_id,NSString *town_id,NSString *name);

@property (assign, nonatomic) NSInteger selectReset;

@end

NS_ASSUME_NONNULL_END
