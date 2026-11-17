//
//  MyViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/18.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyViewController.h"
#import "MacroDefine.h"
#import "MyNaviView.h"
#import "MyHeaderView.h"
#import "MyTableViewCell.h"
#import "MyInfoModel.h"
#import "UserModel.h"
#import "MyHeaderSectionView.h"
#import "MyActivityViewController.h"
#import "SpaceAppointmentHistoryViewController.h"
#import "QuestionLibraryViewController.h"
#import "ComplaintViewController.h"
#import "WorkOrderMessageViewController.h"
#import "SettingViewController.h"
#import "MessageViewController.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet BaseShadowView *iphoneView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (strong, nonatomic)MyHeaderView *myHeaderView;
@property (strong, nonatomic)NSMutableArray *infoArr;

@property (strong, nonatomic) UserModel *userModel;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBackgroundColor = [UIColor clearColor];
    self.hideNavLine = YES;
    self.statusBarStyle = UIStatusBarStyleDefault;
    _myTableView.tableHeaderView = self.myHeaderView;
    _myTableView.tableFooterView = _footerView;
    adjustsScrollViewInsets_NO(_myTableView, self);
        
    [_iphoneView whenTapped:^{
        NSString * phone = [NSString stringWithFormat:@"telprompt://%@",@"021-64835777"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *arr = [CommonUtils getJsonObjectFromLocal:@"myinfo.json"];
    self.infoArr = [MyInfoModel mj_objectArrayWithKeyValuesArray:arr];
    [_myTableView reloadData];
    
    if (!IsStrEmpty([User shareUser].token)) {
        [self getUserDateInfo];
        [self getAuthBaseAppKeyDate];
    } else {
        _myHeaderView.model = nil;
    }
}

- (void)getUserDateInfo
{
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_profileURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.userModel = [UserModel mj_objectWithKeyValues:dic];
            if (IsStrEmpty([User shareUser].getMobile)) {
                [[User shareUser] saveMobile:NONullString(self.userModel.phone)];
                [[User shareUser] saveUserId:NONullString(self.userModel.u_id)];
            }
            self.myHeaderView.model = self.userModel;
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

/// 保存硬件key
- (void)getAuthBaseAppKeyDate
{
    [HttpRequest requestUrlPath:HardwareBaseURL urlPath:auth_base_appKeyURL parameters:@{} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            [[User shareUser] saveApp_key:[NSString stringWithFormat:@"%@",dic[@"app_key"]]];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.infoArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MyHeaderSectionView *sectionHeaderView =  [[[NSBundle mainBundle] loadNibNamed:@"MyHeaderSectionView" owner:self options:nil] firstObject];
    [sectionHeaderView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    MyInfoModel *model = self.infoArr[section];
    sectionHeaderView.sectionTitleLab.text = model.title;
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MyTableViewCell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (MyTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyInfoModel *model = self.infoArr[indexPath.section];
    cell.imageArr = model.image;
    return cell;
}

- (MyHeaderView *)myHeaderView
{
    if (!_myHeaderView) {
        _myHeaderView = [MyHeaderView viewFromXib];
    }
    return _myHeaderView;
}

- (NSMutableArray *)infoArr
{
    if (!_infoArr) {
        _infoArr = [NSMutableArray array];
    }
    return _infoArr;
}

@end
