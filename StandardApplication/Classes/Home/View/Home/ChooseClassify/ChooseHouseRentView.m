//
//  ChooseHouseRentView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/20.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ChooseHouseRentView.h"
#import "MacroDefine.h"
#import "ChooseTableViewCell.h"
#import "SubscribeListModel.h"

@interface ChooseHouseRentView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *chooseTableView;
@property (assign, nonatomic) NSInteger selectUnitIndex;
@end

@implementation ChooseHouseRentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _selectUnitIndex = -1;
    _selectNatureIndex = 0;
    _chooseTableView.delegate = self;
    _chooseTableView.dataSource = self;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    [_chooseTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectIndex == 1 ? _shiArr.count : (_selectIndex == 2 ? _priceDic.allKeys.count : (_selectIndex == 3 ? _natureArr.count : _unitArr.count));
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ChooseTableViewCell";
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = (ChooseTableViewCell *)LoadNibNamed(cellID);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_selectIndex == 1) {
        NSDictionary *dic = _shiArr[indexPath.row];
        NSString *shiValue = dic[@"val"];
        cell.townLab.text = shiValue;
        BOOL isHave = NO;
        for (NSString *value in self.selectShiArr) {
            if ([value isEqualToString:shiValue]) {
                isHave = YES;
                break;
            }
        }
        cell.selectView.backgroundColor = isHave ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor whiteColor];
    } else if (_selectIndex == 2) {
        NSString *priceKey = [self sortPriceAllKeys][indexPath.row];
        cell.townLab.text = priceKey;
        BOOL isHave = NO;
        for (NSString *key in self.selectPriceArr) {
            if ([key isEqualToString:priceKey]) {
                isHave = YES;
                break;
            }
        }
        cell.selectView.backgroundColor = isHave ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor whiteColor];
    } else if (_selectIndex == 3) {
        cell.townLab.text = _natureArr[indexPath.row];
        cell.selectView.backgroundColor = _selectNatureIndex == indexPath.row ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor whiteColor];
    } else if (_selectIndex == 4) {
        UnitModel *model = _unitArr[indexPath.row];
        cell.townLab.text = NONullString(model.contractWorkHouseString);
        cell.selectView.backgroundColor = _selectUnitIndex == indexPath.row ? [UIColor colorWithHexString:@"#2A629A"] : [UIColor whiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == 1) {
        NSDictionary *dic = _shiArr[indexPath.row];
        NSString *shiValue = dic[@"val"];
        NSString *shiKey = [NSString stringWithFormat:@"%@",dic[@"key"]];
        // 选择不限制的情况
        if ([shiValue containsString:@"不限"]) {
            [self.selectShiArr removeAllObjects];
            [self.selectShiArr addObject:shiValue];
            [self.chooseTableView reloadData];
            SAFE_BLOCK(self.chooseHouseShiViewBlock,@"");
            return;
        }
        
        // 选择非不限制情况
        BOOL isHave = NO;
        for (NSString *value in self.selectShiArr) {
            if ([value containsString:@"不限"]) {
                [self.selectShiArr removeObject:value];
            }
            if ([value isEqualToString:shiValue]) {
                isHave = YES;
                break;
            }
        }
        if (isHave) {
            [self.selectShiArr removeObject:shiValue];
            [self.selectShiKeyArr removeObject:shiKey];
        } else {
            [self.selectShiArr addObject:shiValue];
            [self.selectShiKeyArr addObject:shiKey];
        }
        [self.chooseTableView reloadData];

        if (self.selectShiKeyArr.count > 0) {
            SAFE_BLOCK(self.chooseHouseShiViewBlock,[self.selectShiKeyArr mj_JSONString]);
        } else {
            // 取消掉 除不限 的选中，要默认不限
            [self.selectShiArr addObject:@"不限"];
            [self.chooseTableView reloadData];
            SAFE_BLOCK(self.chooseHouseShiViewBlock,@"");
        }
    } else if (_selectIndex == 2) {
        NSString *selectPriceStr = [self sortPriceAllKeys][indexPath.row];
        // 选择不限制的情况
        if ([selectPriceStr containsString:@"不限"]) {
            [self.selectPriceArr removeAllObjects];
            [self.selectPriceArr addObject:selectPriceStr];
            [self.chooseTableView reloadData];
            SAFE_BLOCK(self.chooseHousePriceViewBlock,@"");
            return;
        }
        // 选择非不限制情况
        BOOL isHave = NO;
        for (NSString *key in self.selectPriceArr) {
            if ([key containsString:@"不限"]) {
                [self.selectPriceArr removeObject:key];
            }
            if ([key isEqualToString:selectPriceStr]) {
                isHave = YES;
                break;
            }
        }
        if (isHave) {
            [self.selectPriceArr removeObject:selectPriceStr];
        } else {
            [self.selectPriceArr addObject:selectPriceStr];
        }
        [self.chooseTableView reloadData];
        
        NSMutableArray *priceBlockArr = [NSMutableArray array];
        for (NSString *key in self.selectPriceArr) {
            NSDictionary *valueDic = _priceDic[key];
            NSMutableArray *singlePriceArr = [NSMutableArray array];
            
            [singlePriceArr addObject:[NSString stringWithFormat:@"%ld",[valueDic[@"min"] integerValue] * 100]];
            [singlePriceArr addObject:[NSString stringWithFormat:@"%ld",[valueDic[@"max"] integerValue] * 100]];
            [priceBlockArr addObject:singlePriceArr];
        }
        if (priceBlockArr.count > 0) {
            SAFE_BLOCK(self.chooseHousePriceViewBlock,[priceBlockArr mj_JSONString]);
        } else {
            // 取消掉 除不限 的选中，要默认不限
            [self.selectPriceArr addObject:@"不限"];
            [self.chooseTableView reloadData];
            SAFE_BLOCK(self.chooseHousePriceViewBlock,@"");
        }
    } else if (_selectIndex == 3) {
        _selectNatureIndex = indexPath.row;
        [self.chooseTableView reloadData];
        SAFE_BLOCK(self.chooseHouseNatureViewBlock,_selectNatureIndex);
    } else if (_selectIndex == 4) {
        _selectUnitIndex = indexPath.row;
        [self.chooseTableView reloadData];
        UnitModel *model = _unitArr[indexPath.row];
        NSString *nameStr = NONullString(model.contractWorkHouseString);
        SAFE_BLOCK(self.chooseHouseUnitShiViewBlock,model.unit_id,nameStr);
    }
}

- (NSMutableArray *)sortPriceAllKeys
{
    NSMutableArray *keysArr = [NSMutableArray array];
    if (_priceDic.allKeys == 0) {
        return keysArr;
    }
    NSArray *keysortArr = [_priceDic.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [keysArr addObjectsFromArray:keysortArr];
    for (NSString *key in keysArr) {
        if ([key containsString:@"≥"]) {
            [keysArr removeObject:key];
            [keysArr addObject:key];
            break;
        }
    }
    for (NSString *key in keysArr) {
        if ([key containsString:@"不限"]) {
            [keysArr removeObject:key];
            [keysArr insertObject:key atIndex:0];
            break;
        }
    }
    return keysArr;
}

- (NSMutableArray *)selectPriceArr
{
    if (!_selectPriceArr) {
        _selectPriceArr = [NSMutableArray array];
        [_selectPriceArr addObject:@"不限"];
    }
    return _selectPriceArr;
}
- (NSMutableArray *)selectShiArr
{
    if (!_selectShiArr) {
        _selectShiArr = [NSMutableArray array];
        [_selectShiArr addObject:@"不限"];
    }
    return _selectShiArr;
}
- (NSMutableArray *)selectShiKeyArr
{
    if (!_selectShiKeyArr) {
        _selectShiKeyArr = [NSMutableArray array];
    }
    return _selectShiKeyArr;
}
@end
