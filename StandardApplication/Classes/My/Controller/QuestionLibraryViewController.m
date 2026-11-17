//
//  QuestionLibraryViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/28.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "QuestionLibraryViewController.h"
#import "MacroDefine.h"
#import "SearchNaviView.h"
#import "QuestionLibraryTableViewCell.h"
#import "ProtocolBaseWKWebViewController.h"

@interface QuestionLibraryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) SearchNaviView *searchNaviView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;
@property (weak, nonatomic) IBOutlet UITableView *questionTableView;

@property (strong, nonatomic) NSArray *questionArr;
@property (strong, nonatomic) NSMutableArray *searchQuestionArr;
@end

@implementation QuestionLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.gk_navigationBar addSubview:self.searchNaviView];
    self.hideNavLine = YES;
    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;

    [self getProblemHotDate];
}

- (void)getProblemHotDate
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:problem_hotURL parameters:@{} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.questionArr = arr;
            [self.questionTableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)getProblemSearchDate:(NSString *)keywordStr
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestArrUrlPath:BaseURL urlPath:problem_searchURL parameters:@{@"keyword":NONullString(keywordStr)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (self.searchQuestionArr.count > 0) {
                [self.searchQuestionArr removeAllObjects];
            }
            [self.searchQuestionArr addObjectsFromArray:arr];
            [self.questionTableView reloadData];
        } else if (status == 2) {
            [MBProgressHUD showMessag:@"没找到相关搜索，换个问题试试" toView:self.view];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchQuestionArr.count > 0) {
        return _searchQuestionArr.count;
    }
    return _questionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_searchQuestionArr.count > 0) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_searchQuestionArr.count > 0) {
        return [UIView new];
    }
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UILabel *headerSectionLab = [[UILabel alloc]initWithFrame:CGRectMake(16, 22, SCREEN_WIDTH - 32, 16)];
    headerSectionLab.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightHeavy];
    headerSectionLab.textColor = [UIColor colorWithHexString:@"#040000"];
    headerSectionLab.textAlignment = NSTextAlignmentLeft;
    headerSectionLab.text = @"猜你想问";
    
    [sectionView addSubview:headerSectionLab];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"QuestionLibraryTableViewCell";
    QuestionLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (QuestionLibraryTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.questionNumberLab.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    NSDictionary *dic = [NSDictionary dictionary];
    if (_searchQuestionArr.count > 0) {
        dic = _searchQuestionArr[indexPath.row];
    } else {
        dic = _questionArr[indexPath.row];
    }
    cell.questionLab.text = NONullString(dic[@"title"]);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *questionDic = [NSDictionary dictionary];
    if (_searchQuestionArr.count > 0) {
        questionDic = _searchQuestionArr[indexPath.row];
    } else {
        questionDic = _questionArr[indexPath.row];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:problem_detailURL parameters:@{@"id":@([questionDic[@"id"] integerValue])} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
            if ([dic isKindOfClass:[NSString class]]) {
                vc.htmlStr = (NSString *)dic;
            }
            vc.webTitle = NONullString(questionDic[@"title"]);
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == 2) {
            
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (SearchNaviView *)searchNaviView
{
    if (!_searchNaviView) {
        _searchNaviView = [SearchNaviView viewFromXib];
        _searchNaviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _searchNaviView.searchTextField.textAlignment = NSTextAlignmentCenter;
        _searchNaviView.searchTextField.placeholder = @"问题库";
        KWeakSelf
        _searchNaviView.searchNaviButtonBlock = ^(NSString * _Nonnull text) {
            [weakSelf getProblemSearchDate:text];
        };
        _searchNaviView.searchNaviTextFieldBlock = ^{
            [weakSelf.searchQuestionArr removeAllObjects];
            [weakSelf.questionTableView reloadData];
        };
    }
    return _searchNaviView;
}

- (NSMutableArray *)searchQuestionArr
{
    if (!_searchQuestionArr) {
        _searchQuestionArr = [NSMutableArray array];
    }
    return _searchQuestionArr;
}
@end
