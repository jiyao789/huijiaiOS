//
//  LockListViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/29.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "LockListViewController.h"
#import "MacroDefine.h"
#import "LockListTableViewCell.h"
#import "OpenLockViewController.h"
#import "LockListModel.h"
#import "OpenCarLockViewController.h"
#import "SubscribeListModel.h"

@interface LockListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *lockListTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayoutTop;

@property (strong, nonatomic) NSMutableArray *lockArr;
@property (assign, nonatomic) BOOL isNeedNet;

@end

@implementation LockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self leftBarItem];
    self.navTitle = @"门锁选择";

    self.tableViewLayoutTop.constant = NAVBAR_HEIGHT;
    [self setupOtherBarButtomItemWithTitle:@"刷新" target:self action:@selector(resreshBtnClick) leftOrRight:NO];

    // 检查合同与门锁的关联关系，决定是否需要刷新
    [self checkContractAndAutoRefresh];
}

/**
 * 检查合同与门锁的关联关系，决定是否需要刷新门锁列表
 * 实现逻辑：
 * 1. 获取本地缓存的门锁列表，提取所有 bind_id
 * 2. 调用合同接口 /contract/works，提取所有 unit_id
 * 3. 判断是否需要刷新：
 *    - 如果合同接口调用失败 → 不刷新，使用本地缓存
 *    - 如果没有生效中的合同（返回空列表）→ 触发刷新
 *    - 如果本地门锁的 bind_id 中，有任何一个不在合同的 unit_id 集合内 → 触发刷新
 *    - 如果所有本地门锁的 bind_id 都在合同的 unit_id 集合内 → 不刷新，使用本地缓存
 */
- (void)checkContractAndAutoRefresh
{
    // 1. 获取本地缓存的门锁列表
    [HttpRequest cacheResponseObject:HardwareBaseURL
                             urlPath:lock_device_listingURL
                          parameters:@{@"provider":@"sciener",
                                      @"app_key":NONullString([User shareUser].getApp_key),
                                      @"username":NONullString([User shareUser].getMobile)}
                          isNeedNet:NO  // 使用本地缓存
                                type:HttpRequestTypeGet
                              result:^(id  _Nonnull objs, NSInteger status, NSString * _Nonnull msg) {
        NSMutableSet *localBindIds = [NSMutableSet set];

        if (status == 1 || status == 2) {
            if ([objs isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)objs;
                NSArray *lockListArr = [LockListModel mj_objectArrayWithKeyValuesArray:dic[@"devices"]];

                // 提取本地门锁的 bind_id，过滤掉当前锁类型不匹配的门锁
                for (LockListModel *model in lockListArr) {
                    if (model.lock_type == self.lock_type && model.bind_id > 0) {
                        [localBindIds addObject:@(model.bind_id)];
                    }
                }

                NSLog(@"[门锁检查] 本地缓存的门锁 bind_id 集合: %@", localBindIds);
            }
        }

        // 2. 调用合同接口获取生效中的合同
        [HttpRequest requestArrUrlPath:BaseURL
                               urlPath:contract_worksURL
                            parameters:@{}
                                  type:HttpRequestTypeGet
                                result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {

            // 3. 判断是否需要刷新
            if (status != 1) {
                // 合同接口调用失败 → 不刷新，使用本地缓存
                NSLog(@"[门锁检查] 合同接口调用失败，使用本地缓存");
                self->_isNeedNet = NO;
                [self getLockDeviceListDate:NO];
                return;
            }

            // 提取合同的 unit_id 集合
            NSMutableSet *contractUnitIds = [NSMutableSet set];
            NSArray *unitArr = [UnitModel mj_objectArrayWithKeyValuesArray:arr];
            for (UnitModel *unit in unitArr) {
                if (unit.unit_id > 0) {
                    [contractUnitIds addObject:@(unit.unit_id)];
                }
            }

            NSLog(@"[门锁检查] 生效中合同的 unit_id 集合: %@", contractUnitIds);

            if (contractUnitIds.count == 0) {
                // 没有生效中的合同 → 触发刷新
                NSLog(@"[门锁检查] 没有生效中的合同，触发刷新");
                self->_isNeedNet = YES;
                [self getLockDeviceListDate:YES];
                return;
            }

            if (localBindIds.count == 0) {
                // 本地没有缓存的门锁 → 触发刷新
                NSLog(@"[门锁检查] 本地没有缓存的门锁，触发刷新");
                self->_isNeedNet = YES;
                [self getLockDeviceListDate:YES];
                return;
            }

            // 检查本地门锁的 bind_id 是否都在合同的 unit_id 集合内
            BOOL hasInvalidLock = NO;
            NSMutableArray *invalidBindIds = [NSMutableArray array];
            for (NSNumber *bindId in localBindIds) {
                if (![contractUnitIds containsObject:bindId]) {
                    hasInvalidLock = YES;
                    [invalidBindIds addObject:bindId];
                }
            }

            if (hasInvalidLock) {
                // 存在失效的门锁 → 触发刷新
                NSLog(@"[门锁检查] 检测到失效的门锁 bind_id: %@，触发刷新", invalidBindIds);
                self->_isNeedNet = YES;
                [self getLockDeviceListDate:YES];
            } else {
                // 所有门锁都有效 → 不刷新，使用本地缓存
                NSLog(@"[门锁检查] 所有门锁都有效，使用本地缓存");
                self->_isNeedNet = NO;
                [self getLockDeviceListDate:NO];
            }
        }];
    }];
}

- (void)resreshBtnClick
{
    _isNeedNet = YES;
    [self getLockDeviceListDate:YES];
}

- (void)getLockDeviceListDate:(BOOL)isNeedNet
{
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest cacheResponseObject:HardwareBaseURL urlPath:lock_device_listingURL parameters:@{@"provider":@"sciener",@"app_key":NONullString([User shareUser].getApp_key),@"username":NONullString([User shareUser].getMobile)} isNeedNet:isNeedNet type:HttpRequestTypeGet result:^(id  _Nonnull objs, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            if (self.lockArr.count > 0) {
                [self.lockArr removeAllObjects];
            }
            if ([objs isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)objs;
                NSMutableArray *lockListArr = [NSMutableArray array];
                [lockListArr addObjectsFromArray:[LockListModel mj_objectArrayWithKeyValuesArray:dic[@"devices"]]];
                [self.lockArr addObjectsFromArray:lockListArr];
                for (LockListModel *model in lockListArr) {
                    if (model.lock_type != self.lock_type) {
                        [self.lockArr removeObject:model];
                    }
                }
                if (self.lockArr.count == 0) {
                    [self.lockListTableView addSubview:self.noMsgView];
                } else {
                    [self.noMsgView removeFromSuperview];
                }
                [self.lockListTableView reloadData];
            }
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lockArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LockListTableViewCell";
    LockListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (LockListTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.lockListModel = _lockArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IsStrEmpty([User shareUser].getApp_key)) {
        [MBProgressHUD showMessag:@"app_key不存在" toView:self.view];
        return;
    }
    LockListModel *model = _lockArr[indexPath.row];
    if (self.lock_type == 2) {
        OpenLockViewController *vc = [OpenLockViewController new];
        vc.isNeedNet = _isNeedNet;
        vc.device_id = model.device_id;
        vc.unit_id = model.bind_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.lock_type == 7) {
        OpenCarLockViewController *vc = [OpenCarLockViewController new];
        vc.isNeedNet = _isNeedNet;
        vc.device_id = model.device_id;
        vc.unit_id = model.bind_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSMutableArray *)lockArr
{
    if (!_lockArr) {
        _lockArr = [NSMutableArray array];
    }
    return _lockArr;
}
@end
