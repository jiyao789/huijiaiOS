//
//  WorkOrderDetailMyTextTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/21.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "WorkOrderDetailMyTextTableViewCell.h"
#import "KNPhotoBrowser.h"

@implementation WorkOrderDetailMyTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    KWeakSelf
    [_myImageView whenTapped:^{
        [weakSelf lookImageView];
    }];
}

- (void)setModel:(WorkOrderDetailModel *)model
{
    _model = model;
    if (IsStrEmpty(model.msg)) {
        _myTextLayoutTop.constant = 0;
        _myTextLayoutBottom.constant = 0;
    } else {
        _myTextLayoutTop.constant = 15;
        _myTextLayoutBottom.constant = 15;
    }
    _myTextLab.text = NONullString(model.msg);
    if (_model.imageArr.count == 0) {
        _myImageView.hidden = YES;
        _myImageViewLayoutTop.constant = 0;
        _myImageViewLayoutHeight.constant = 0;
    } else {
        _myImageView.hidden = NO;
        _myImageViewLayoutTop.constant = 10;
        _myImageViewLayoutHeight.constant = 153;
        [_myImageView setImageUrl:[NSString stringWithFormat:@"%@",_model.imageArr.firstObject] placeholderImage:defaultIconName];
    }
    if (IsStrEmpty(_model.msg) && _model.imageArr.count == 0) {
        _myIconImageView.hidden = YES;
    } else {
        _myIconImageView.hidden = NO;
    }
}

- (void)lookImageView
{
    NSMutableArray *datas = [NSMutableArray array];
    KNPhotoItems *items = [[KNPhotoItems alloc] init];
    items.sourceView = _myImageView;
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
