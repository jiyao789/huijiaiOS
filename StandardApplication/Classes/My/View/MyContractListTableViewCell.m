//
//  MyContractListTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyContractListTableViewCell.h"

@implementation MyContractListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ContractListModel *)model
{
    _model = model;
    [_contractImageView setImageUrl:NONullString(_model.unit.image_url) placeholderImage:defaultIconName];
    _contractNameLab.text = NONullString(_model.house);
    _contractTimeLab.text = [NSString stringWithFormat:@"%@——%@",_model.start_date,_model.end_date];
    _contractPriceLab.text = NONullString(_model.rentalString);
    _contractNumberLab.text = NONullString(_model.number);
    _contractStatusLab.text = NONullString(_model.statusString);
    _contractStatusLab.textColor = _model.statusColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
