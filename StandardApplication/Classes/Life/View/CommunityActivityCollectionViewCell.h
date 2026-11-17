//
//  CommunityActivityCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/25.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "LifeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityActivityCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (strong, nonatomic) ListModel *model;
@end

NS_ASSUME_NONNULL_END
