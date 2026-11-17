//
//  MyContractListTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "ContractListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyContractListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contractImageView;
@property (weak, nonatomic) IBOutlet UILabel *contractNameLab;
@property (weak, nonatomic) IBOutlet UILabel *contractTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *contractPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *contractNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *contractStatusLab;


@property (strong, nonatomic) ContractListModel *model;
@end

NS_ASSUME_NONNULL_END
