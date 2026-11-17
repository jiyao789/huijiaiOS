//
//  CommunityActivityDetailViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CommunityActivityDetailViewController.h"
#import "MacroDefine.h"
#import "RNStackScrollView.h"
#import "CommunityActivityWebView.h"
#import "CommunityActivityDetailTableViewCell.h"
#import "ActivityListModel.h"
#import <IQKeyboardManager.h>
#import "ActivityDetailBottomView.h"

@interface CommunityActivityDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) RNStackScrollView *contentScrollView;
@property (strong, nonatomic) CommunityActivityWebView *headerView;
@property (strong, nonatomic) ActivityDetailBottomView *activityDetailBottomView;
@property (strong, nonatomic) ActivityListModel *activityListModel;
@end

@implementation CommunityActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self leftBarItem];
    self.navTitle = @"活动详情";
    
    adjustsScrollViewInsets_NO(self.contentScrollView, self);
    
    self.contentScrollView = [[RNStackScrollView alloc] initWithViewArray:@[self.myTableView,self.headerView.myWebView]];
    self.contentScrollView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- NAVBAR_HEIGHT);
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.headerView.progressView];
    
    [self getActivityInfoDate];
    
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)getActivityInfoDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:activity_infoURL parameters:@{@"act_id":@(_act_id)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            self.activityListModel = [ActivityListModel mj_objectWithKeyValues:dic];
            
            if (IsStrEmpty(self.activityListModel.link)) {
                self.headerView.webContentStr = self.activityListModel.content;
                [self.headerView loadWebView];
            } else {
                self.headerView.webUrl = self.activityListModel.link;
                [self.headerView loadWebView];
            }
            
            if (self.activityListModel.status == 1) {
                self.contentScrollView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- NAVBAR_HEIGHT - 200);
                [self.contentScrollView tableViewWillReload];
                self.activityDetailBottomView.activityListModel = self.activityListModel;
                self.activityDetailBottomView.navigation = self.navigationController;
                [self.view addSubview:self.activityDetailBottomView];
            }
            
            
            [self.myTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_activityListModel.type isEqualToString:@"憓家发现"]) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CommunityActivityDetailTableViewCell";
    CommunityActivityDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (CommunityActivityDetailTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.activityListModel = _activityListModel;
    return cell;
}

- (UITableView *)myTableView
{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.backgroundColor = [UIColor clearColor];
    }
    return _myTableView;
}

- (CommunityActivityWebView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[CommunityActivityWebView alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH - 32, SCREEN_HEIGHT)];
    }
    return _headerView;
}

- (ActivityDetailBottomView *)activityDetailBottomView
{
    if (!_activityDetailBottomView) {
        _activityDetailBottomView = [ActivityDetailBottomView viewFromXib];
        _activityDetailBottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
    }
    return _activityDetailBottomView;
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
-(void)keyboardWillChangeFrameNotify:(NSNotification*)notify {

    // 0.取出键盘动画的时间
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + transformY - 200);
        self.activityDetailBottomView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
