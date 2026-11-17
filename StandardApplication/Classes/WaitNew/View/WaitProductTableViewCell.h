//
//  WaitProductTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "NewWaitProjctListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitProductTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *aresLab;
@property (weak, nonatomic) IBOutlet UICollectionView *poinsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *productInfoLab;
@property (weak, nonatomic) IBOutlet QMUIButton *mobileButton;

@property (strong, nonatomic) NewWaitProjctListModel *model;
@property (strong, nonatomic) NSArray *tagsArr;
@end

NS_ASSUME_NONNULL_END
