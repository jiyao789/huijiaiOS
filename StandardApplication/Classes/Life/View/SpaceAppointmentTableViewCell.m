//
//  SpaceAppointmentTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceAppointmentTableViewCell.h"
#import "SpaceAppointmentListViewController.h"
#import "SpaceAppointmentDetailViewController.h"
#import "XHPageControl.h"

@interface SpaceAppointmentTableViewCell()
@property (strong, nonatomic) XHPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *bannarTitleArr;
@end

@implementation SpaceAppointmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _moreButton.imagePosition = QMUIButtonImagePositionRight;
    _moreButton.spacingBetweenImageAndTitle = 5;
    
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScroll = YES;
}

- (void)setModel:(LifeModel *)model
{
    _model = model;
    _titleLab.text = NONullString(_model.name);
    NSMutableArray *bannarImageArr = [NSMutableArray array];
    NSMutableArray *bannarTitleArr = [NSMutableArray array];
    for (ListModel *listModel in _model.list) {
        [bannarImageArr addObject:listModel.image_url];
        [bannarTitleArr addObject:listModel.title];
    }
    _cycleScrollView.showPageControl = NO;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:defaultIconName];
    _cycleScrollView.imageURLStringsGroup = bannarImageArr;
    if (bannarImageArr.count > 1) {
        self.pageControl.numberOfPages = bannarImageArr.count;
    }
    [self.bannarTitleArr addObjectsFromArray:bannarTitleArr];
    _contentLab.text = NONullString(self.bannarTitleArr.firstObject);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    _contentLab.text = NONullString(self.bannarTitleArr[index]);
    self.pageControl.currentPage = index;
}

- (XHPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, 170 , SCREEN_WIDTH - 52, 12)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentMultiple = 1;
        _pageControl.otherColor = [UIColor whiteColor];
        _pageControl.currentColor = [UIColor colorWithHexString:@"#2A629A"];
        [self.cycleScrollView addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        SpaceAppointmentDetailViewController *vc = [SpaceAppointmentDetailViewController new];
        ListModel *model = _model.list[index];
        vc.spaceId = model.id;
        [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
    }];
}

- (NSMutableArray *)bannarTitleArr
{
    if (!_bannarTitleArr) {
        _bannarTitleArr = [NSMutableArray array];
    }
    return _bannarTitleArr;
}

- (IBAction)moreBtnClick:(id)sender
{
    [[CommonUtils getCurrentViewController].navigationController pushViewController:[SpaceAppointmentListViewController new] animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
