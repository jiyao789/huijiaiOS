//
//  CommunityActivityTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "LifeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityActivityTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UICollectionView *communityCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet QMUIButton *moreButton;

@property (strong, nonatomic) LifeModel *lifeModel;
@end

NS_ASSUME_NONNULL_END
