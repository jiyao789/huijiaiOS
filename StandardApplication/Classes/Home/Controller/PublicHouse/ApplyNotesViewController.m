//
//  ApplyNotesViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ApplyNotesViewController.h"
#import "MacroDefine.h"
#import "ApplyNotesTableViewCell.h"
#import "PublicApplyTestViewController.h"
#import "NewsListModel.h"
#import "ProtocolBaseWKWebViewController.h"

@interface ApplyNotesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *qualificationTestBtn;
@property (weak, nonatomic) IBOutlet UITableView *applyNotesTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (strong, nonatomic) NSArray *newsListArr;
@end

@implementation ApplyNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"资格申请须知";
    
    PSBarButtonItem *item = [[PSBarButtonItem alloc] initWithCustomView:self.qualificationTestBtn];
    self.gk_navItemRightSpace = 15;
    self.gk_navRightBarButtonItem = item;
    
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    [self setupHeaderRefresh:self.applyNotesTableView];
    
    [self getNewsListDate];
}

- (void)getNewsListDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:news_listURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.newsListArr = [NewsListModel mj_objectArrayWithKeyValuesArray:arr];
            [self.applyNotesTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    [self getNewsListDate];
    [self.applyNotesTableView.mj_header endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _newsListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NewsListModel *listModel = _newsListArr[section];
    return listModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NewsListModel *listModel = _newsListArr[section];
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UILabel *headerSectionLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 21, SCREEN_WIDTH - 32, 16)];
    headerSectionLab.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightHeavy];
    headerSectionLab.textColor = [UIColor blackColor];
    headerSectionLab.textAlignment = NSTextAlignmentLeft;
    headerSectionLab.text = NONullString(listModel.type);
    
    [sectionView addSubview:headerSectionLab];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ApplyNotesTableViewCell";
    ApplyNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (ApplyNotesTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NewsListModel *listModel = _newsListArr[indexPath.section];
    NewsModel *model = listModel.list[indexPath.row];
    cell.applyTitleLab.text = NONullString(model.title);
    cell.applyTitleLab.textColor = indexPath.section == 0 ? [UIColor colorWithHexString:@"#2C6DB0"] : [UIColor colorWithHexString:@"#231815"];
    cell.applyTimeLab.text = NONullString(model.created_time);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsListModel *listModel = _newsListArr[indexPath.section];
    NewsModel *model = listModel.list[indexPath.row];
    
    ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
    vc.webTitle = NONullString(model.title);
    vc.webUrl = NONullString(model.file_url);
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)qualificationTestBtn
{
    if (_qualificationTestBtn == nil) {
        _qualificationTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qualificationTestBtn.frame = KFrame(0, 0, 68, 30);
        [_qualificationTestBtn setTitle:@"资格测试" forState:UIControlStateNormal];
        [_qualificationTestBtn setBackgroundColor:[UIColor colorWithHexString:@"#2A629A"]];
        [_qualificationTestBtn addTarget:self action:@selector(qualificationTestBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _qualificationTestBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_qualificationTestBtn setTitleColor:[UIColor colorWithHexString:@"#EEF1F5"] forState:UIControlStateNormal];
        _qualificationTestBtn.layer.cornerRadius = 12;
        _qualificationTestBtn.layer.masksToBounds = YES;
    }
    return _qualificationTestBtn;
}

- (void)qualificationTestBtnClick
{
    [self.navigationController pushViewController:[PublicApplyTestViewController new] animated:YES];
}

- (NSArray *)newsListArr
{
    if (!_newsListArr) {
        _newsListArr = [NSArray array];
    }
    return _newsListArr;
}

@end
