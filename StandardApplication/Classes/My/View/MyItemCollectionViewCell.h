//
//  MyItemCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2024/10/14.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) ImageModel *model;
@end

NS_ASSUME_NONNULL_END
