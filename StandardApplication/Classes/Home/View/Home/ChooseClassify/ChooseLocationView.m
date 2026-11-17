//
//  ChooseLocationView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ChooseLocationView.h"
#import "MacroDefine.h"
#import "RegionTableViewCell.h"
#import "ChooseTableViewCell.h"
#import "CountyTownModel.h"

@interface ChooseLocationView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *regionTableView;
@property (weak, nonatomic) IBOutlet UITableView *streetTableView;

@property (strong, nonatomic) NSArray *countyArr;
@property (strong, nonatomic) NSArray *townArr;
@property (assign, nonatomic) NSInteger countySelectIndex;
@property (strong, nonatomic) NSMutableArray *selectTownArr;
@end

@implementation ChooseLocationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _regionTableView.delegate = self;
    _regionTableView.dataSource = self;
    
    _streetTableView.delegate = self;
    _streetTableView.dataSource = self;
    
    _countySelectIndex = 0;
    [self getBasicCountyDate];
    
}

- (void)setSelectReset:(NSInteger)selectReset
{
    _countySelectIndex = 0;
    [self.selectTownArr removeAllObjects];
    [self getBasicCountyDate];
}

- (void)getBasicCountyDate
{
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:basic_countyURL parameters:@{@"city_id":@"310100000000"} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.countyArr = [CountyTownModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.countyArr.count > 0) {
                CountyTownModel *countyModel = self.countyArr[0];
                [self getBasicTownDate:countyModel.county_id];
            }
            [self.regionTableView reloadData];
        }
    }];
}

- (void)getBasicTownDate:(NSInteger)countyId
{
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:basic_townURL parameters:@{@"county_id":@(countyId)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.townArr = [TownModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.townArr.count > 0) {
                TownModel *model = self.townArr[0];
                model.isSelect = YES;
            }
            [self.streetTableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 0 ? _countyArr.count: _townArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        static NSString *cellID = @"RegionTableViewCell";
        RegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (RegionTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = _countyArr[indexPath.row];
        cell.selectImageView.hidden = _countySelectIndex == indexPath.row ? NO : YES;
        return cell;
    } else if (tableView.tag == 1) {
        static NSString *cellID = @"ChooseTableViewCell";
        ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = (ChooseTableViewCell *)LoadNibNamed(cellID);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        TownModel *townModel = _townArr[indexPath.row];
        cell.model = townModel;
        cell.selectView.backgroundColor = townModel.isSelect ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor whiteColor];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        CountyTownModel *countyModel = _countyArr[indexPath.row];
        NSMutableArray *selectCountyArr = [NSMutableArray array];
        [selectCountyArr addObject:[NSString stringWithFormat:@"%ld",(long)countyModel.county_id]];
        
        _countySelectIndex = indexPath.row;
        [self getBasicTownDate:countyModel.county_id];
        
        [self.regionTableView reloadData];
        
        SAFE_BLOCK(self.chooseLocationViewBlock,_countySelectIndex == 0 ? @"" : [selectCountyArr mj_JSONString],@"",@"");
    } else if (tableView.tag == 1) {
        
        CountyTownModel *countyModel = _countyArr[_countySelectIndex];
        NSMutableArray *selectCountyArr = [NSMutableArray array];
        [selectCountyArr addObject:[NSString stringWithFormat:@"%ld",(long)countyModel.county_id]];
        
        TownModel *townModel = self.townArr[indexPath.row];
        
        // 选中全部，其他选项不能选中
        if (indexPath.row == 0) {
            for (TownModel *model in self.townArr) {
                model.isSelect = NO;
            }
            townModel.isSelect = YES;
            [self.streetTableView reloadData];
            SAFE_BLOCK(self.chooseLocationViewBlock,_countySelectIndex == 0 ? @"" : [selectCountyArr mj_JSONString],@"",@"");
            return;
        }
        
        // 选中其他选项
        townModel.isSelect = !townModel.isSelect;
        if (townModel.isSelect) {
            if (self.townArr.count > 0) {
                TownModel *townModel = self.townArr[0];
                townModel.isSelect = NO;
                [self.selectTownArr removeObject:[NSString stringWithFormat:@"%ld",(long)townModel.town_id]];
            }
            [self.selectTownArr addObject:[NSString stringWithFormat:@"%ld",(long)townModel.town_id]];
        } else {
            for (NSString *townId in self.selectTownArr) {
                if ([townId integerValue] == townModel.town_id) {
                    [self.selectTownArr removeObject:townId];
                    break;
                }
            }
        }
        
        // 取消掉其他全部选项
        if (self.selectTownArr.count == 0 && self.townArr.count > 0) {
            TownModel *townModel = self.townArr[0];
            townModel.isSelect = YES;
            [self.streetTableView reloadData];
            SAFE_BLOCK(self.chooseLocationViewBlock,_countySelectIndex == 0 ? @"" : [selectCountyArr mj_JSONString],@"",@"");
            return;
        }
        [self.streetTableView reloadData];
        SAFE_BLOCK(self.chooseLocationViewBlock,[selectCountyArr mj_JSONString],[self.selectTownArr mj_JSONString],[NSString stringWithFormat:@"%@%@",countyModel.name,townModel.name]);
    }
}

- (NSMutableArray *)selectTownArr
{
    if (!_selectTownArr) {
        _selectTownArr = [NSMutableArray array];
    }
    return _selectTownArr;
}

@end
