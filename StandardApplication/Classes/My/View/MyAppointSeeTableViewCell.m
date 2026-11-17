//
//  MyAppointSeeTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyAppointSeeTableViewCell.h"
#import "MacroDefine.h"
#import "MyAppointSeeDetailViewController.h"
#import "MyReserveDetailViewController.h"

@implementation MyAppointSeeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setType:(NSInteger)type
{
    _type = type;
    [_applyBtn setTitle:(_type == 0 ? @"取消约看" : @"取消预定") forState:UIControlStateNormal];
    _appointSeeTimeLab.hidden = (_type == 0 ? NO : YES);
}

- (void)setSubscribeListModel:(SubscribeListModel *)subscribeListModel
{
    _subscribeListModel = subscribeListModel;
    if (_subscribeListModel.classInt == 1) {
        [_appointImageView setImageUrl:_subscribeListModel.unit.imgs placeholderImage:defaultIconName];
        _appointNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_subscribeListModel.unit.region_name),NONullString(_subscribeListModel.unit.shiString)];
        _appointNatureLab.text = _subscribeListModel.unit.nature == 1 ? @"公租" : @"社租";
        _appointConfigLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_subscribeListModel.unit.area,NONullString(_subscribeListModel.unit.shiString),NONullString(_subscribeListModel.unit.towardString)];
        _priceLab.text = NONullString(_subscribeListModel.unit.priceString);
        _appointSeeTimeLab.text = @"";
    //    [NSString stringWithFormat:@"约看时间：%@ %@",NONullString(_subscribeListModel.book_date),NONullString(_subscribeListModel.time_slot)];
    } else if (_subscribeListModel.classInt == 2) {
        [_appointImageView setImageUrl:_subscribeListModel.house.main_img placeholderImage:defaultIconName];
        _appointNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_subscribeListModel.house.neighborhood_name),NONullString(_subscribeListModel.house.bedroom_num_string)];
        _appointNatureLab.text = @"大房鸭";
        _appointConfigLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_subscribeListModel.house.total_area,NONullString(_subscribeListModel.house.bedroom_num_string),NONullString(_subscribeListModel.house.orientation)];
        _priceLab.text = NONullString(_subscribeListModel.house.priceString);
        _appointSeeTimeLab.text = @"";
    //    [NSString stringWithFormat:@"约看时间：%@ %@",NONullString(_subscribeListModel.book_date),NONullString(_subscribeListModel.time_slot)];
    }
}

- (void)setAppointListModel:(AppointListModel *)appointListModel
{
    _appointListModel = appointListModel;
    [_appointImageView setImageUrl:_appointListModel.unit.image_url placeholderImage:defaultIconName];
    _appointNameLab.text = [NSString stringWithFormat:@"%@%@",NONullString(_appointListModel.region.name),NONullString(_appointListModel.unit.shiString)];
    _appointNatureLab.text = _appointListModel.unit.nature == 1 ? @"公租" : @"社租";
    _appointConfigLab.text = [NSString stringWithFormat:@"%.2f㎡    |    %@    |    %@",_appointListModel.unit.area,NONullString(_appointListModel.unit.shiString),NONullString(_appointListModel.unit.towardString)];
    _priceLab.text = NONullString(_appointListModel.unit.priceString);
}

- (IBAction)cancelBtnClick:(id)sender
{
    if (_type == 0) {
        MyAppointSeeDetailViewController *vc = [MyAppointSeeDetailViewController new];
        vc.book_id = _subscribeListModel.id;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    } else if (_type == 1) {
        MyReserveDetailViewController *vc = [MyReserveDetailViewController new];
        vc.book_id = _appointListModel.book_id;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
