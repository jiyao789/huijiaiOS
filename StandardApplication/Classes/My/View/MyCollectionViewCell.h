//
//  MyCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"
#import "MacroDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myNameLab;
@property (weak, nonatomic) IBOutlet BaseShadowView *bgView;
@property (strong, nonatomic)ImageModel *model;
@end

NS_ASSUME_NONNULL_END
