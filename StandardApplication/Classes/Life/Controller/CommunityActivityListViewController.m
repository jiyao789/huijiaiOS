//
//  CommunityActivityListViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CommunityActivityListViewController.h"
#import "MacroDefine.h"
#import "CommunityActivityListTableViewCell.h"
#import "CommunityActivityDetailViewController.h"
#import "ActivityListModel.h"
#import "ProtocolBaseWKWebViewController.h"

@interface CommunityActivityListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *activityArr;
@end

@implementation CommunityActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = _titleStr;
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT + 5;
    _pageIndex = 1;
    [self setupRefreshWithTableView:_listTableView];
    
    [self getActivityListData];
}

- (void)getActivityListData
{
    NSString *urlPath = _type == 1 ? BaseURL : ReleaseBaseURL;
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:urlPath urlPath:activity_listURL parameters:@{@"type":@(_type),@"page":@(_pageIndex),@"page_rows":@"10"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (_pageIndex == 1 && self.activityArr.count > 0) {
                [self.activityArr removeAllObjects];
            }
            NSArray *listArr = dic[@"list"];
            [self.activityArr addObjectsFromArray:[ActivityListModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.listTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.listTableView.mj_footer endRefreshing];
            }
            if (self.activityArr.count == 0) {
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
    [self getActivityListData];
    [_listTableView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getActivityListData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _activityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CommunityActivityListTableViewCell";
    CommunityActivityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (CommunityActivityListTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.activityListModel = _activityArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityListModel *model = _activityArr[indexPath.row];
//    if (!IsStrEmpty(model.link)) {
//        ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
//        vc.webUrl = NONullString(model.link);
//        vc.webTitle = @"活动详情";
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    CommunityActivityDetailViewController *vc = [CommunityActivityDetailViewController new];
    vc.act_id = model.act_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)activityArr
{
    if (!_activityArr) {
        _activityArr = [NSMutableArray array];
    }
    return _activityArr;
}

@end
