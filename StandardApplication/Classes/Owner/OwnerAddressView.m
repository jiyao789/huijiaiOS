//
//  OwnerAddressView.m
//  StandardApplication
//
//  Created by DTiOS on 2022/2/16.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "OwnerAddressView.h"
#import "MacroDefine.h"
#import "RegionTableViewCell.h"
#import "ChooseTableViewCell.h"
#import "CountyTownModel.h"

@interface OwnerAddressView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *countyArr;
@property (strong, nonatomic) NSArray *townArr;

@end

@implementation OwnerAddressView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _countyTableView.delegate = self;
    _countyTableView.dataSource = self;
    
    _townTableView.delegate = self;
    _townTableView.dataSource = self;
    
}

- (void)setCountySelectIndex:(NSInteger)countySelectIndex
{
    _countySelectIndex = countySelectIndex;
    [self getBasicCountyDate];
}

- (void)setTownSelectIndex:(NSInteger)townSelectIndex
{
    _townSelectIndex = townSelectIndex;
    [self.townTableView reloadData];
}

- (void)getBasicCountyDate
{
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:basic_county_noAllURL parameters:@{@"city_id":@"310100000000"} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.countyArr = [CountyTownModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.countyArr.count > 0) {
                CountyTownModel *countyModel = self.countyArr[_countySelectIndex];
                [self getBasicTownDate:countyModel.county_id];
            }
            [self.countyTableView reloadData];
        }
    }];
}

- (void)getBasicTownDate:(NSInteger)countyId
{
    [HttpRequest requestArrUrlPath:ReleaseBaseURL urlPath:basic_town_noAllURL parameters:@{@"county_id":@(countyId)} type:HttpRequestTypeGet result:^(NSArray * _Nonnull arr, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.townArr = [TownModel mj_objectArrayWithKeyValuesArray:arr];
            if (self.townArr.count > 0) {
                TownModel *model = self.townArr[0];
                model.isSelect = YES;
            }
            [self.townTableView reloadData];
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
        cell.model = _townArr[indexPath.row];
        cell.selectView.backgroundColor = _townSelectIndex == indexPath.row ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor whiteColor];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        CountyTownModel *countyModel = _countyArr[indexPath.row];
        _countySelectIndex = indexPath.row;
        _townSelectIndex = 0;
        [self getBasicTownDate:countyModel.county_id];
        
        [self.countyTableView reloadData];

    } else if (tableView.tag == 1) {
        _townSelectIndex = indexPath.row;
        
        [self.townTableView reloadData];
    }
}
- (IBAction)resetBtnClick:(id)sender
{
    _countySelectIndex = 0;
    _townSelectIndex = 0;
    SAFE_BLOCK(self.resetLocationViewBlock);
}

- (IBAction)commitBtnClick:(id)sender
{
    CountyTownModel *countyModel = _countyArr[_countySelectIndex];
    TownModel *townModel = self.townArr[_townSelectIndex];
    SAFE_BLOCK(self.chooseLocationViewBlock,countyModel.county_id,townModel.town_id,[NSString stringWithFormat:@"%@%@",countyModel.name,townModel.name],_countySelectIndex,_townSelectIndex);
}
@end
