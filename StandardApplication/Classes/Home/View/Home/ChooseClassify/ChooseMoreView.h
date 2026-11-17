//
//  ChooseMoreView.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseMoreView : UIView
@property (nonatomic, copy) void (^chooseMoreViewBlock)(NSString *points);
@property (strong, nonatomic) NSArray *pointArr;
@property (assign, nonatomic) NSInteger selectReset;
@end

NS_ASSUME_NONNULL_END
