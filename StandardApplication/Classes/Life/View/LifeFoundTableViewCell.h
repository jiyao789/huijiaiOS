//
//  LifeFoundTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2022/8/3.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "LifeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LifeFoundTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *lifeFoundCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet QMUIButton *moreButton;

@property (strong, nonatomic) LifeModel *lifeModel;
@end

NS_ASSUME_NONNULL_END
