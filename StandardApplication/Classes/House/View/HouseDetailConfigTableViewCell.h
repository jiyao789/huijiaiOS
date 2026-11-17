//
//  HouseDetailConfigTableViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface HouseDetailConfigTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *houseConfigCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) NSArray *furnitureArr;
@property (strong, nonatomic) NSString *facilities;
@property (strong, nonatomic) NSMutableArray *facilitiesArr;
@end

NS_ASSUME_NONNULL_END
