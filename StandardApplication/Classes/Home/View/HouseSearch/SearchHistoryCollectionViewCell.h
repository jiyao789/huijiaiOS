//
//  SearchHistoryCollectionViewCell.h
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *historySearchLab;
@property (nonatomic, copy) void (^removeIndexButtonBlock)(NSString *text);
@end

NS_ASSUME_NONNULL_END
