//
//  HouseBannerTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "HouseBannerTableViewCell.h"
#import "XHPageControl.h"
#import "KNPhotoBrowser.h"

@interface HouseBannerTableViewCell ()
@property (strong, nonatomic) XHPageControl *pageControl;
@end

@implementation HouseBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = YES;
    _cycleScrollView.showPageControl = NO;
}

- (void)setModel:(NewWaitProjctListModel *)model
{
    _model = model;
    _cycleScrollView.imageURLStringsGroup = _model.images;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:defaultIconName];
    if (_model.images.count > 1) {
        self.pageControl.numberOfPages = _model.images.count;
        _cycleScrollView.showPageControl = YES;
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.pageControl.currentPage = index;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableArray *datas = [NSMutableArray array];
    for (NSString *imageUrlStr in _model.images) {
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        items.sourceView = cycleScrollView;
        items.url = imageUrlStr;
        [datas addObject:items];
    }
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
    photoBrowser.currentIndex = index;
    [photoBrowser present];
}

- (XHPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, 160 , SCREEN_WIDTH - 32, 12)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentMultiple = 1;
        _pageControl.otherColor = [UIColor whiteColor];
        _pageControl.currentColor = [UIColor colorWithHexString:@"#2A629A"];
        [self.cycleScrollView addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
