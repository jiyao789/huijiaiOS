//
//  WorkOrderDetailTextTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "WorkOrderDetailTextTableViewCell.h"
#import "KNPhotoBrowser.h"

@implementation WorkOrderDetailTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    KWeakSelf
    [_systemImageView whenTapped:^{
        [weakSelf lookImageView];
    }];
}

- (void)setModel:(WorkOrderDetailModel *)model
{
    _model = model;
    if (IsStrEmpty(_model.msg)) {
        _systemTextLayoutTop.constant = 0;
        _systemTextLayoutBottom.constant = 0;
    } else {
        _systemTextLayoutTop.constant = 15;
        _systemTextLayoutBottom.constant = 15;
    }
    _sysTextLab.text = NONullString(_model.msg);
    if (_model.imageArr.count == 0) {
        _systemImageView.hidden = YES;
        _systemImageViewLayoutTop.constant = 0;
        _systemImageViewLayoutHeight.constant = 0;
    } else {
        _systemImageView.hidden = NO;
        _systemImageViewLayoutTop.constant = 10;
        _systemImageViewLayoutHeight.constant = 153;
        [_systemImageView setImageUrl:[NSString stringWithFormat:@"%@",_model.imageArr.firstObject] placeholderImage:defaultIconName];
    }
    if (IsStrEmpty(_model.msg) && _model.imageArr.count == 0) {
        _systemIconImageView.hidden = YES;
    } else {
        _systemIconImageView.hidden = NO;
    }
}

- (void)lookImageView
{
    NSMutableArray *datas = [NSMutableArray array];
    KNPhotoItems *items = [[KNPhotoItems alloc] init];
    items.sourceView = _systemImageView;
    items.url = [NSString stringWithFormat:@"%@",_model.imageArr.firstObject];
    [datas addObject:items];
    
    if (datas.count == 0) {
        return;
    }
    KNPhotoBrowser *photoBrowser = [[KNPhotoBrowser alloc] init];
    photoBrowser.itemsArr = datas;
//    photoBrowser.isNeedPageControl = true; // if it has video to play , I do not suggest you to use PageControl
    photoBrowser.isNeedPageNumView = true;
//    photoBrowser.isNeedRightTopBtn = true;
    photoBrowser.isNeedPrefetch = true;
    photoBrowser.isNeedPanGesture = true;
    photoBrowser.isNeedAutoPlay = true;
    photoBrowser.currentIndex = 0;
    [photoBrowser present];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
