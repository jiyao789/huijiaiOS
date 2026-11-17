//
//  RmtNewsViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2024/10/28.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import "RmtNewsViewController.h"
#import "MacroDefine.h"
#import "ProtocolBaseWKWebViewController.h"
#import "NewsInfoModel.h"
#import "RmtNewsCollectionViewCell.h"
#import "RmtTitleCollectionViewCell.h"

@interface RmtNewsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *rmtNewsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLayoutTop;

@property (assign, nonatomic) NSInteger pageIndex;
@property (strong, nonatomic) NSMutableArray *rmtNewsArr;
@end

@implementation RmtNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = _titleStr;
    self.collectionViewLayoutTop.constant = NAVBAR_HEIGHT;
    _rmtNewsCollectionView.delegate = self;
    _rmtNewsCollectionView.dataSource = self;
    [_rmtNewsCollectionView registerNib:[UINib nibWithNibName:@"RmtNewsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RmtNewsCollectionViewCell"];
    [_rmtNewsCollectionView registerNib:[UINib nibWithNibName:@"RmtTitleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RmtTitleCollectionViewCell"];
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    _pageIndex = 1;
    [self setupRefreshWithTableView:_rmtNewsCollectionView];
    
    [self getRmtNewsDataInfo];
}

- (void)getRmtNewsDataInfo
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseApiURL urlPath:news_ewdCloudListURL parameters:@{@"page":@(_pageIndex), @"page_rows":@(10)} type:HttpRequestTypeGet result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1) {
            if (self.rmtNewsArr.count > 0 && _pageIndex == 1) {
                [self.rmtNewsArr removeAllObjects];
            }
            NSArray *listArr = [dic valueForKey:@"list"];
            [self.rmtNewsArr addObjectsFromArray: [NewsInfoModel mj_objectArrayWithKeyValuesArray:listArr]];
            if (listArr.count < 10) {
                [self.rmtNewsCollectionView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.rmtNewsCollectionView.mj_footer endRefreshing];
            }
            if (self.rmtNewsArr.count == 0) {
                [self.rmtNewsCollectionView addSubview:self.noMsgView];
            } else {
                [self.noMsgView removeFromSuperview];
            }
            [self.rmtNewsCollectionView reloadData];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)headerRefreshloadData
{
    _pageIndex = 1;
    [self getRmtNewsDataInfo];
    [_rmtNewsCollectionView.mj_header endRefreshing];
}

- (void)footerRefreshloadData
{
    _pageIndex ++;
    [self getRmtNewsDataInfo];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _rmtNewsArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = floor(SCREEN_WIDTH - 24);
    NewsInfoModel * model = _rmtNewsArr[indexPath.item];
    CGFloat itemHeight = [CommonUtils getNewsHeightWithModel:model];
    return CGSizeMake(itemWidth, itemHeight);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsInfoModel * model = _rmtNewsArr[indexPath.item];
    if (IsStrEmpty(model.image_url)) {
        RmtTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RmtTitleCollectionViewCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    RmtNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RmtNewsCollectionViewCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsInfoModel *model = _rmtNewsArr[indexPath.item];
    ProtocolBaseWKWebViewController *webVc = [[ProtocolBaseWKWebViewController alloc] init];
    webVc.webTitle = NONullString(model.title);
    webVc.webUrl = NONullString(model.file_url);
    [[CommonUtils getCurrentViewController].navigationController pushViewController:webVc animated:YES];
}

- (NSMutableArray *)rmtNewsArr
{
    if (!_rmtNewsArr) {
        _rmtNewsArr = [NSMutableArray array];
    }
    return _rmtNewsArr;
}
@end
