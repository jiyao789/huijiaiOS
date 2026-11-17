//
//  MyContractListViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/27.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyContractListViewController.h"
#import "MacroDefine.h"
#import "MyContractListTableViewCell.h"
#import "MyContractDetailViewController.h"
#import "ContractListModel.h"

@interface MyContractListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *contractTableView;

@property (strong, nonatomic) NSArray *contractListArr;
@end

@implementation MyContractListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"我的合同";
    
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    [self setupHeaderRefresh:_contractTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getContractListdate];
}

- (void)getContractListdate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:contract_my_listURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.contractListArr = [ContractListModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.contractListArr.count == 0) {
                [self.contractTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.contractTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    [self getContractListdate];
    [_contractTableView.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contractListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyContractListTableViewCell";
    MyContractListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (MyContractListTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = _contractListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContractListModel *model = _contractListArr[indexPath.row];
    MyContractDetailViewController *vc = [MyContractDetailViewController new];
    vc.cid = model.c_id;
    vc.end_date = model.end_date;
    vc.contract_id = model.number;
    vc.contractStatus = model.status;
    vc.webUrl = IsNilOrNull(model.viewpdf_url) ? @"" : model.viewpdf_url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)contractListArr
{
    if (!_contractListArr) {
        _contractListArr = [NSArray array];
    }
    return _contractListArr;
}

@end
