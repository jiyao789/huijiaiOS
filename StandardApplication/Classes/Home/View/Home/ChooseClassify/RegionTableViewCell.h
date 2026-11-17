//
//  RegionTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "CountyTownModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countyLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (strong, nonatomic) CountyTownModel *model;
@end

NS_ASSUME_NONNULL_END
