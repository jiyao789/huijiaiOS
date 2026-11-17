//
//  NewWaitViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "NewWaitViewController.h"
#import "ChooseClassifyView.h"
#import "MacroDefine.h"
#import "NewWaitTableViewCell.h"
#import "NewWaitDetailViewController.h"
#import "NewWaitProjctListModel.h"

@interface NewWaitViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet ChooseClassifyView *chooseClassifyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseClassifyViewLayoutHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chooseClassifyViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *houseTableView;
@property (strong, nonatomic) NSMutableArray *houseListArr;
@property (strong, nonatomic) NSMutableDictionary *unitFilterDic;

@end

@implementation NewWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self leftBarItem];
    self.navTitle = @"轮候房源";
    _chooseClassifyViewLayoutTop.constant = NAVBAR_HEIGHT + 5;
    
    [self setupHeaderRefresh:_houseTableView];
    
    KWeakSelf
    _chooseClassifyView.isHouseType = 3;
    _chooseClassifyView.ChooseClassifyViewBlock = ^(NSInteger height) {
        weakSelf.chooseClassifyViewLayoutHeight.constant = height + 60;
    };
    _chooseClassifyView.chooseClassifyViewFilterBlock = ^(NSMutableDictionary * _Nullable unitFilterDic) {
        weakSelf.unitFilterDic = unitFilterDic;
        [weakSelf getUnitIndexDate];
    };
}

- (void)getUnitIndexDate
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (_unitFilterDic) {
        [para addEntriesFromDictionary:_unitFilterDic];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:cityWaiting_project_indexURL parameters:para type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            if (self.houseListArr.count > 0) {
                [self.houseListArr removeAllObjects];
            }
            [self.houseListArr addObjectsFromArray:[NewWaitProjctListModel mj_objectArrayWithKeyValuesArray:arr]];
            [self.houseTableView.mj_footer endRefreshingWithNoMoreData];
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
    [self getUnitIndexDate];
    [_houseTableView.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _houseListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 128;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"NewWaitTableViewCell";
    NewWaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (NewWaitTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NewWaitProjctListModel *model = _houseListArr[indexPath.row];
    cell.waitListModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewWaitProjctListModel *model = _houseListArr[indexPath.row];
    NewWaitDetailViewController *vc = [NewWaitDetailViewController new];
    vc.id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createNotificationCenterInfo:(HouseListModel *)model
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HomeCollectNotification" object:nil userInfo:model.mj_keyValues];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseCollectNotification" object:nil userInfo:model.mj_keyValues];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getUnitIndexDate];
    
}

- (NSMutableArray *)houseListArr
{
    if (!_houseListArr) {
        _houseListArr = [NSMutableArray array];
    }
    return _houseListArr;
}


@end
