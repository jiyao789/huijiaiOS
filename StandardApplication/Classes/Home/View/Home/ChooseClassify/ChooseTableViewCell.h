//
//  ChooseTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "CountyTownModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UILabel *townLab;

@property (strong, nonatomic) TownModel *model;
@end

NS_ASSUME_NONNULL_END
