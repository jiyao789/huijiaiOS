//
//  LifeFoundCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2022/8/3.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "LifeModel.h"
#import "ChangeSpaceLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LifeFoundCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lifeImageView;
@property (weak, nonatomic) IBOutlet ChangeSpaceLabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) ListModel *model;
@end

NS_ASSUME_NONNULL_END
