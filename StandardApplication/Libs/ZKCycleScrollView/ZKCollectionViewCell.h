//
//  ZKCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2019/7/29.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *zkImageView;
@property (weak, nonatomic) IBOutlet UILabel *zkTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *liveStatusButton;
@property (weak, nonatomic) IBOutlet UIImageView *livePlayImageView;

@end

NS_ASSUME_NONNULL_END
