//
//  AcquisitionListVC.m
//  StandardApplication
//
//  Property acquisition declaration list view controller - Matching prototype design
//

#import "AcquisitionListVC.h"
#import "MacroDefine.h"
#import "YDInterfaceDefinition.h"
#import "AcquisitionListCell.h"
#import "AcquisitionListItemModel.h"
#import "AcquisitionStep1VC.h"
#import "AcquisitionStep5VC.h"
#import "AcquisitionFormData.h"

@interface AcquisitionListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<AcquisitionListItemModel *> *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation AcquisitionListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftBarItem];
    self.navTitle = @"我的申报";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];

    _pageIndex = 1;
    _dataArray = [NSMutableArray array];

    [self setupUI];
    [self setupRefreshWithTableView:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)setupUI {
    // TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[AcquisitionListCell class] forCellReuseIdentifier:@"AcquisitionListCell"];
    [self.view addSubview:_tableView];

    // Layout
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVBAR_HEIGHT + 10);
        make.bottom.equalTo(self.view);
    }];
}

- (void)loadData {
    [HttpRequest requestUrlPath:BaseURL urlPath:acquisitionDeclaration_listURL parameters:@{@"page": @(_pageIndex), @"rows": @(10)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        [self.tableView.mj_header endRefreshing];

        if (status == 1) {
            if (_pageIndex == 1 && self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }

            NSArray *listArr = dic[@"list"];
            NSArray *models = [AcquisitionListItemModel mj_objectArrayWithKeyValuesArray:listArr];
            [self.dataArray addObjectsFromArray:models];

            if (listArr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }

            if (self.dataArray.count == 0) {
                [self.tableView addSubview:self.noMsgView];
                self.noMsgView.center = CGPointMake(self.tableView.bounds.size.width / 2, self.tableView.bounds.size.height / 2 - 50);
            } else {
                [self.noMsgView removeFromSuperview];
            }

            [self.tableView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData {
    _pageIndex = 1;
    [self loadData];
}

- (void)footerRefreshloadData {
    _pageIndex++;
    [self loadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AcquisitionListCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AcquisitionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcquisitionListCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AcquisitionListItemModel *model = _dataArray[indexPath.row];
    AcquisitionStep5VC *vc = [[AcquisitionStep5VC alloc] init];
    vc.declarationId = model.itemId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
