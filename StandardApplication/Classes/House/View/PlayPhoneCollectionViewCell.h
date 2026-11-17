//
//  PlayPhoneCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "PhoneInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayPhoneCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) PhoneInfoModel *phoneInfoModel;
@end

NS_ASSUME_NONNULL_END
