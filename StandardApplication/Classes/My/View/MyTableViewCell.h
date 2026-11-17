//
//  MyTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/26.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *itemCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *itemLayout;


@property (strong, nonatomic)NSArray *imageArr;

@end

NS_ASSUME_NONNULL_END
