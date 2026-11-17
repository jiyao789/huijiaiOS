//
//  PlayPhoneCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "PlayPhoneCollectionViewCell.h"

@implementation PlayPhoneCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setType:(NSInteger)type
{
    _type = type;
    if (_type == 2) {
        _nameLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        _phoneLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _playBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    } else if (_type == 1) {
        _nameLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        _phoneLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _playBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    }
}

- (void)setPhoneInfoModel:(PhoneInfoModel *)phoneInfoModel
{
    _phoneInfoModel = phoneInfoModel;
    _nameLab.text = NONullString(_phoneInfoModel.name);
    _phoneLab.text = NONullString(_phoneInfoModel.phone);
}

- (IBAction)playPhoneBtnClick:(id)sender
{
    NSString * phone = [NSString stringWithFormat:@"telprompt://%@",NONullString(_phoneInfoModel.phone)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
}

@end
