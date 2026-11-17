//
//  NewWaitTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2023/12/9.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewWaitProjctListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewWaitTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *houseAmountLab;
@property (weak, nonatomic) IBOutlet UICollectionView *poinsCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (strong, nonatomic) NewWaitProjctListModel *waitListModel;
@property (strong, nonatomic) NSArray *tagsArr;
@end

NS_ASSUME_NONNULL_END
