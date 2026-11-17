//
//  SpaceAppointmentListViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SpaceAppointmentListViewController.h"
#import "MacroDefine.h"
#import "SpaceAppointmentListTableViewCell.h"
#import "SpaceAppointmentHistoryViewController.h"
#import "SpaceAppointmentDetailViewController.h"
#import "SpaceIndexModel.h"

@interface SpaceAppointmentListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *spaceListArr;
@end

@implementation SpaceAppointmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"空间预约";
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    _pageIndex = 1;
    [self setupRefreshWithTableView:_listTableView];
    [self setupOtherBarButtomItemWithTitle:@"我的预约" target:self action:@selector(myAppointmentBtnEvent) leftOrRight:NO];
    
    [self getSpaceIndexDateInfo];
}

- (void)getSpaceIndexDateInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:space_indexURL parameters:@{@"page":@(_pageIndex),@"page_rows":@(10)} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.spaceListArr.count > 0) {
                [self.spaceListArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.spaceListArr addObjectsFromArray:[SpaceIndexModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.listTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.listTableView.mj_footer endRefreshing];
            }
            if (self.spaceListArr.count == 0) {
                [self.listTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.listTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getSpaceIndexDateInfo];
    [_listTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getSpaceIndexDateInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _spaceListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SpaceAppointmentListTableViewCell";
    SpaceAppointmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (SpaceAppointmentListTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.spaceModel = _spaceListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentNavgationController:self.navigationController loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        SpaceAppointmentDetailViewController *vc = [SpaceAppointmentDetailViewController new];
        SpaceIndexModel *model = _spaceListArr[indexPath.row];
        vc.spaceId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (void)myAppointmentBtnEvent
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentNavgationController:self.navigationController loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        SpaceAppointmentHistoryViewController *vc = [SpaceAppointmentHistoryViewController new];
        vc.type = @"life";
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (NSMutableArray *)spaceListArr
{
    if (!_spaceListArr) {
        _spaceListArr = [NSMutableArray array];
    }
    return _spaceListArr;
}

@end
