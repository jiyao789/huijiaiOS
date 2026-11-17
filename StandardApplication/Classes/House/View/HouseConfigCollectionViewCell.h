//
//  HouseConfigCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseConfigCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) NSDictionary *pointDic;
@property (weak, nonatomic) IBOutlet UIImageView *configImageView;
@property (weak, nonatomic) IBOutlet UILabel *configNameLab;
@end

NS_ASSUME_NONNULL_END
