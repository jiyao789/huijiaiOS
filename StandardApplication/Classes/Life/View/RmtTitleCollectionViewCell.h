//
//  RmtTitleCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2024/10/25.
//  Copyright © 2024 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "NewsInfoModel.h"
#import "ChangeSpaceLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RmtTitleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet ChangeSpaceLabel *titleLab;

@property (strong, nonatomic) NewsInfoModel *model;
@end

NS_ASSUME_NONNULL_END
