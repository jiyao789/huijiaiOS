//
//  MyTableViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "MyTableViewCell.h"
#import "MacroDefine.h"
#import "MyItemCollectionViewCell.h"
#import "QuestionLibraryViewController.h"
#import "SettingViewController.h"
#import "MyActivityViewController.h"
#import "SpaceAppointmentHistoryViewController.h"
#import "ComplaintViewController.h"
#import "WorkOrderMessageViewController.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _itemCollectionView.delegate = self;
    _itemCollectionView.dataSource = self;
    CGFloat secondSpace = (SCREEN_WIDTH - 20 * 2 - 60 * 4) / 3;
    _itemLayout.minimumLineSpacing = 0;
    _itemLayout.minimumInteritemSpacing = secondSpace;
    _itemLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _itemLayout.itemSize = CGSizeMake(60, 100);
    [_itemCollectionView registerNib:[UINib nibWithNibName:@"MyItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyItemCollectionViewCell"];
}

- (void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
    [_itemCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyItemCollectionViewCell" forIndexPath:indexPath];
    cell.model = _imageArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageModel *imageModel = _imageArr[indexPath.row];
    if (imageModel.actionType == 3) {
        [[CommonUtils getCurrentViewController].navigationController pushViewController:[QuestionLibraryViewController new] animated:YES];
        return;
    }
    if (imageModel.actionType == 6) {
        [[CommonUtils getCurrentViewController].navigationController pushViewController:[SettingViewController new] animated:YES];
        return;
    }
    [[CommonUtils sharedCommonUtils] judgeUserLoginWithCurrentController:[CommonUtils getCurrentViewController] loginSuccessed:^(NSString *authorization, BOOL performLogin) {
        if (performLogin) {
            [[CommonUtils getCurrentViewController].navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self pushController:imageModel];
        }
    }];
}

- (void)pushController:(ImageModel *)model
{
    switch (model.actionType) {
        case 1:
        {
            [[CommonUtils getCurrentViewController].navigationController pushViewController:[MyActivityViewController new] animated:YES];
            break;
        }
        case 2:
        {
            SpaceAppointmentHistoryViewController *vc = [SpaceAppointmentHistoryViewController new];
            vc.type = @"my";
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            [[CommonUtils getCurrentViewController].navigationController pushViewController:[ComplaintViewController new] animated:YES];
            break;
        }
        case 5:
        {
            WorkOrderMessageViewController *vc = [WorkOrderMessageViewController new];
            vc.type = @"my";
            [[CommonUtils getCurrentViewController].navigationController pushViewController:vc animated:YES];
            break;
        }
        case 7:
        {
            Class acquisitionListVCClass = NSClassFromString(@"AcquisitionListVC");
            if (acquisitionListVCClass) {
                [[CommonUtils getCurrentViewController].navigationController pushViewController:[acquisitionListVCClass new] animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
