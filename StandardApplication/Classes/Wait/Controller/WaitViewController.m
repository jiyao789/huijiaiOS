//
//  WaitViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/6/17.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitViewController.h"
#import "HouseSearchNaviView.h"
#import "ChooseClassifyView.h"
#import "HomeHouseTableViewCell.h"
#import "HouseDetailViewController.h"
#import "PublicHouseClassifyView.h"
#import "MessageIndexModel.h"
#import "SearchViewController.h"
#import "MessageViewController.h"
#import "WaitNotesViewController.h"
#import "WaitNumberViewController.h"
#import "WaitingDetailModel.h"
#import "MyWaitViewController.h"

@interface WaitViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewLayoutTop;
@property (weak, nonatomic) IBOutlet BaseShadowView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *noReadLab;
@property (weak, nonatomic) IBOutlet QMUIButton *messageBtn;
@property (weak, nonatomic) IBOutlet ChooseClassifyView *chooseClassifyView;
@property (weak, nonatomic) IBOutlet UIImageView *waitGetNumberImageView;
@property (weak, nonatomic) IBOutlet PublicHouseClassifyView *publicHouseClassifyView;
@property (weak, nonatomic) IBOutlet UITableView *houseTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseClassifyViewLayoutHeight;
@property (weak, nonatomic) IBOutlet QMUIButton *backBtn;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *houseListArr;
@property (strong, nonatomic) NSMutableDictionary *unitFilterDic;
@property (assign, nonatomic) NSInteger unit_type;
@property (strong, nonatomic) NSString *recodeTokenStr;
@end

@implementation WaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.naviBarAlpha = 0;
    self.hideNaviBar = YES;
    [self leftBarItem];
    _searchViewLayoutTop.constant = STATUSBAR_HEIGHT + 7;
    _messageBtn.imagePosition = QMUIButtonImagePositionTop;
    _messageBtn.spacingBetweenImageAndTitle = 2;
    _backBtn.imagePosition = QMUIButtonImagePositionTop;
    _backBtn.spacingBetweenImageAndTitle = 2;
    
    _pageIndex = 1;
    _unit_type = 0;
    [self setupRefreshWithTableView:_houseTableView];
    
    KWeakSelf
    _chooseClassifyView.isHouseType = 2;
    _chooseClassifyView.ChooseClassifyViewBlock = ^(NSInteger height) {
        weakSelf.chooseClassifyViewLayoutHeight.constant = height;
    };
    _chooseClassifyView.chooseClassifyViewFilterBlock = ^(NSMutableDictionary * _Nullable unitFilterDic) {
        weakSelf.unitFilterDic = unitFilterDic;
        weakSelf.pageIndex = 1;
        [weakSelf getUnitIndexDate];
    };
    _publicHouseClassifyView.publicHouseClassifyViewBlock = ^(NSInteger unit_type) {
        weakSelf.unit_type = unit_type;
    };
    [_searchView whenTapped:^{
        SearchViewController *vc = [SearchViewController new];
        vc.nature = 1;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [_waitGetNumberImageView whenTapped:^{
        [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
            if (!performLogin) {
                [weakSelf getUnitWaitingDate];
            }
        }];
    }];
}

- (void)getUnitWaitingDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:unitWaiting_infoURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            WaitingDetailModel *waitingDetailModel = [WaitingDetailModel mj_objectWithKeyValues:dic];
            if (!IsNilOrNull(waitingDetailModel)) {
                if (waitingDetailModel.status == 3 || waitingDetailModel.status == 4) {
                    WaitNumberViewController *vc = [WaitNumberViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                MyWaitViewController *vc = [MyWaitViewController new];
                vc.backType = @"previous";
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (status == 400) {
            WaitNumberViewController *vc = [WaitNumberViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)getUnitIndexDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@(_pageIndex) forKey:@"page"];
    [para setObject:@(10) forKey:@"page_rows"];
    [para setObject:@(1) forKey:@"nature"];   //1:公租房 2:社租房
    [para setObject:NONullString([User shareUser].getUserId) forKey:@"u_id"];
    if (_unitFilterDic) {
        [para addEntriesFromDictionary:_unitFilterDic];
    }
    if (_unit_type != 0) {
        [para setObject:@(_unit_type) forKey:@"unit_type"];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:unit_indexURL parameters:para type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.houseListArr.count > 0) {
                [self.houseListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.houseListArr addObjectsFromArray:[HouseListModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.houseTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.houseTableView.mj_footer endRefreshing];
            }
            if (self.houseListArr.count == 0) {
                [self.houseTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.houseTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getUnitIndexDate];
    [_houseTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getUnitIndexDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _houseListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"HomeHouseTableViewCell";
    HomeHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (HomeHouseTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    HouseListModel *model = _houseListArr[indexPath.row];
    cell.houseModel = model;
//    KWeakSelf
//    cell.houseIsCollectBlock = ^(NSInteger collect) {
//        model.collect = collect;
//        [weakSelf createNotificationCenterInfo:model];
//    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HouseDetailViewController *vc = [HouseDetailViewController new];
    HouseListModel *model = _houseListArr[indexPath.row];
    vc.unit_id = model.unit_id;
//    KWeakSelf
//    vc.houseIsCollectBlock = ^(NSInteger collect) {
//        model.collect = collect;
//        [weakSelf createNotificationCenterInfo:model];
//    };
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
        [[SNFileCache defaultCache] saveDictionary:model forKey:@"House"];
    });
}

//- (void)createNotificationCenterInfo:(HouseListModel *)model
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:model.mj_keyValues];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _pageIndex = 1;
    [self getUnitIndexDate];
    
//    if (self.houseListArr.count > 0) {
//        KWeakSelf
//        [RACObserve([User shareUser],token) subscribeNext:^(id x) {
//            if (![x isEqual:weakSelf.recodeTokenStr]) {
//                weakSelf.recodeTokenStr = x;
//                weakSelf.pageIndex = 1;
//                [weakSelf getUnitIndexDate];
//            }
//        }];
//    }
    if (!IsStrEmpty([User shareUser].token)) {
        [self getMessageDate];
    }
}

- (void)getMessageDate
{
    [HttpRequest requestUrlPath:BaseURL urlPath:appMessage_indexURL parameters:@{@"page":@(1),@"page_rows":@"1"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            MessageIndexModel *messageIndexModel = [MessageIndexModel mj_objectWithKeyValues:dic[@"list"]];
            _noReadLab.hidden = messageIndexModel.mark == 0 ? YES : NO;
            _noReadLab.text = [NSString stringWithFormat:@"  %ld  ",(long)messageIndexModel.mark];
        } else {
            self.noReadLab.hidden = YES;
        }
    }];
}

- (NSMutableArray *)houseListArr
{
    if (!_houseListArr) {
        _houseListArr = [NSMutableArray array];
    }
    return _houseListArr;
}

- (IBAction)messageBtnClick:(id)sender
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        if (!performLogin) {
            MessageViewController *vc = [MessageViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (IBAction)waitNotesBtnClick:(id)sender
{
    WaitNotesViewController *vc = [WaitNotesViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
