//
//  MyActivityViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyActivityViewController.h"
#import "MacroDefine.h"
#import "SpaceAppointmentListTableViewCell.h"
#import "CommunityActivityDetailViewController.h"
#import "MyActivityListModel.h"

@interface MyActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *myActivityTableView;

@property (strong, nonatomic) NSArray *activityListArr;
@end

@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"我参与的活动";
    [self setupHeaderRefresh:_myActivityTableView];
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    
    [self getMyActivityDate];
}

- (void)getMyActivityDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:activity_my_applyURL parameters:@{@"search":@"history"} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.activityListArr = [MyActivityListModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.activityListArr.count == 0) {
                [self.myActivityTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.myActivityTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    [self getMyActivityDate];
    [_myActivityTableView.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _activityListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SpaceAppointmentListTableViewCell";
    SpaceAppointmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (SpaceAppointmentListTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.applyBtn.hidden = YES;
    cell.myActivityListModel = _activityListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyActivityListModel *model = _activityListArr[indexPath.row];
    CommunityActivityDetailViewController *vc = [CommunityActivityDetailViewController new];
    vc.act_id = model.activity.act_id;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
