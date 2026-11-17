//
//  LifeViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "LifeViewController.h"
#import "MacroDefine.h"
#import "LifeMyNaviView.h"
#import "CommunityActivityTableViewCell.h"
#import "SpaceAppointmentTableViewCell.h"
#import "SpaceAppointmentDetailViewController.h"
#import "LifeModel.h"
@import WechatOpenSDK;
#import "NoticeShowView.h"
#import "CommunityActivityListViewController.h"
#import "CommunityActivityDetailViewController.h"
#import "LifeFoundTableViewCell.h"
#import "ActivityReviewTableViewCell.h"
#import "RmtNewsTableViewCell.h"
#import "NewsInfoModel.h"

@interface LifeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)LifeMyNaviView *lifeMyNaviView;
@property (weak, nonatomic) IBOutlet UITableView *lifeTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (strong, nonatomic) IBOutlet UIView *headerTableView;
@property (weak, nonatomic) IBOutlet UIImageView *repariImageView;
@property (weak, nonatomic) IBOutlet UIImageView *redCommunityImageView;

@property (strong, nonatomic) NSArray *lifeArr;
@property (strong, nonatomic) NSMutableArray *newsArr;
@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.lifeMyNaviView.navTitleLab.text = @"憓家生活";
    [self.gk_navigationBar addSubview:self.lifeMyNaviView];
    self.hideNaviBar = YES;
    self.hideNavLine = YES;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self setupHeaderRefresh:_lifeTableView];
    _lifeTableView.tableHeaderView = _headerTableView;
    adjustsScrollViewInsets_NO(_lifeTableView, self);
    
    [self getActivityHomeDate];
    
    [self getRmtNewsDataInfo];
    
    [_repariImageView whenTapped:^{
        // 1. 弹出二次确认弹窗
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"即将离开当前应用，跳转至“保洁报修”小程序"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        // 取消按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        // 确定按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 2. 判断是否安装微信
            BOOL wxIsInstalled = [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
            if (!wxIsInstalled) {
                [MBProgressHUD showMessag:@"请先安装微信" toView:nil];
                return;
            }
            
            // 3. 执行跳转逻辑
            WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
            launchMiniProgramReq.userName = @"gh_fb08a5879dfd"; // 小程序原始ID
            launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; // 正式版
            
            [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
                // 跳转回调处理
            }];
        }]];
        
        // 弹出弹窗（注意：如果你在非 ViewController 环境下，需要获取当前顶层 VC 弹出）
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    KWeakSelf
    [_redCommunityImageView whenTapped:^{
        [weakSelf showRedCommunityInfo];
    }];
}

- (void)getRmtNewsDataInfo
{
    [HttpRequest requestUrlPath:BaseApiURL urlPath:news_ewdCloudListURL parameters:@{@"page":@(1), @"page_rows":@(4)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            if (self.newsArr.count > 0) {
                [self.newsArr removeAllObjects];
            }
            NSArray *listArr = [dic valueForKey:@"list"];
            [self.newsArr addObjectsFromArray: [NewsInfoModel mj_objectArrayWithKeyValuesArray:listArr]];
            [self.lifeTableView reloadData];
        }
    }];
}

- (void)showRedCommunityInfo
{
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        
        [MBProgressHUD showStatus:nil toView:nil];
        [HttpRequest requestUrlPath:BaseURL urlPath:activity_listURL parameters:@{@"type":@(1),@"page":@(1),@"page_rows":@"10"} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
            [MBProgressHUD dismissWithView:nil];
            if (status == 1 || status == 2) {
                CommunityActivityListViewController *vc = [CommunityActivityListViewController new];
                vc.type = 1;
                vc.titleStr = @"红色社区";
                [self.navigationController pushViewController:vc animated:YES];
            } else if (status == 400) {
                [self showNoticeShowView:msg];
            } else {
                [MBProgressHUD showMessag:msg toView:nil];
            }
        }];
    }];
}

- (void)showNoticeShowView:(NSString *)message
{
    NoticeShowView *noticeShowView = [NoticeShowView createViewFromNib];
    noticeShowView.noticeLab.text = NONullString(message);
    noticeShowView.frame = CGRectMake(0, 0, 260, 145);
    ScottAlertViewController *alertController = [ScottAlertViewController alertControllerWithAlertView:noticeShowView preferredStyle:ScottAlertControllerStyleAlert transitionAnimationStyle:ScottAlertTransitionStyleFade];
    noticeShowView.didCancelBlock = ^{
        [alertController dismissViewControllerAnimated:YES];
    };
    alertController.tapBackgroundDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getActivityHomeDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:ReleaseBaseURL urlPath:activity_homeURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            NSArray *dataArr = dic[@"data"];
            self.lifeArr = [LifeModel mj_objectArrayWithKeyValuesArray:dataArr];
            [self.lifeTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    [self getActivityHomeDate];
    [self getRmtNewsDataInfo];
    [_lifeTableView.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lifeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeModel *model = _lifeArr[indexPath.row];
    if (model.type == 6) {
        CGFloat height = 0;
        for (NSInteger index = 0; index < _newsArr.count; index ++) {
            NewsInfoModel * model = _newsArr[index];
            height += [CommonUtils getNewsHeightWithModel: model];
        }
        return height + 50;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeModel *model = _lifeArr[indexPath.row];
    if (model.type == 4) {
        static NSString *cellID = @"SpaceAppointmentTableViewCell";
        SpaceAppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (SpaceAppointmentTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = model;
        return cell;
    }
    if (model.type == 5) {
        static NSString *cellID = @"LifeFoundTableViewCell";
        LifeFoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (LifeFoundTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lifeModel = model;
        return cell;
    }
    if (model.type == 3) {
        static NSString *cellID = @"ActivityReviewTableViewCell";
        ActivityReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (ActivityReviewTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lifeModel = model;
        return cell;
    }
    if (model.type == 6) {
        static NSString *cellID = @"RmtNewsTableViewCell";
        RmtNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (RmtNewsTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lifeModel = model;
        cell.rmtNewsList = _newsArr;
        return cell;
    }
    static NSString *cellID = @"CommunityActivityTableViewCell";
    CommunityActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (CommunityActivityTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lifeModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LifeModel *model = _lifeArr[indexPath.row];
    KWeakSelf
    if (model.type == 4) {
        [[CommonUtils sharedCommonUtils]judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
            [weakSelf.navigationController pushViewController:[SpaceAppointmentDetailViewController new] animated:YES];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > NAVBAR_HEIGHT) {
        self.hideNaviBar = NO;
        self.statusBarStyle = UIStatusBarStyleDefault;
    } else {
        self.hideNaviBar = YES;
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (LifeMyNaviView *)lifeMyNaviView
{
    if (!_lifeMyNaviView) {
        _lifeMyNaviView = [LifeMyNaviView viewFromXib];
        _lifeMyNaviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    }
    return _lifeMyNaviView;
}

- (NSArray *)lifeArr
{
    if (!_lifeArr) {
        _lifeArr = [NSArray array];
    }
    return _lifeArr;
}

- (NSMutableArray *)newsArr
{
    if (!_newsArr) {
        _newsArr = [NSMutableArray array];
    }
    return _newsArr;
}

@end
