//
//  ShowMapSelectHouseView.h
//  StandardApplication
//
//  Created by DTiOS on 2022/8/4.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowMapSelectHouseView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITableView *mapHouseTableView;

@property (strong, nonatomic) NSString *houseNameStr;
@property (nonatomic, copy) void (^didDismissBlock) (void);
@property (strong, nonatomic) UINavigationController *navigation;
@end

NS_ASSUME_NONNULL_END
