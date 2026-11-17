//
//  WaitNotesViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/6/17.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "WaitNotesViewController.h"
#import "MacroDefine.h"
#import "WaitNotesTableViewCell.h"
#import "WaitNotesModel.h"
#import "ProtocolBaseWKWebViewController.h"

@interface WaitNotesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *waitNoteTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopLayout;
@property (strong, nonatomic) NSMutableArray *waitListArr;
@end

@implementation WaitNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"轮候须知";
    [self leftBarItem];
    _viewTopLayout.constant = NAVBAR_HEIGHT;
    [self setupHeaderRefresh:_waitNoteTableView];
    
    [self getWaitListInfo];
}

- (void)headerRefreshloadData
{
    [self getWaitListInfo];
    [_waitNoteTableView.mj_header endRefreshing];
}

- (void)getWaitListInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:news_waitingListURL parameters:@{} type:HttpRequestTypePost result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:self.view];
        if (status == 1) {
            if (self.waitListArr.count > 0) {
                [self.waitListArr removeAllObjects];
            }
            [self.waitListArr addObjectsFromArray:[WaitNotesModel mj_objectArrayWithKeyValuesArray:arr]];
            if (self.waitListArr.count == 0) {
                [self.waitNoteTableView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.waitNoteTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _waitListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 10 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"WaitNotesTableViewCell";
    WaitNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (WaitNotesTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WaitNotesModel *model = _waitListArr[indexPath.section];
    cell.waitTitleLab.text = NONullString(model.title);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaitNotesModel *model = _waitListArr[indexPath.section];
    ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
    vc.webTitle = NONullString(model.title);
    vc.webUrl = NONullString(model.file_url);
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)waitListArr
{
    if (!_waitListArr) {
        _waitListArr = [NSMutableArray array];
    }
    return _waitListArr;
}

@end
