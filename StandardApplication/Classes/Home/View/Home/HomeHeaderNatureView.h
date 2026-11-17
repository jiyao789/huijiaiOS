//
//  HomeHeaderNatureView.h
//  StandardApplication
//
//  Created by DTiOS on 2023/8/24.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoinsModel : NSObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger region_id;
@property (retain, nonatomic) NSString *region_name;
@property (assign, nonatomic) BOOL select;
@end

@interface HomeHeaderNatureView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, copy) void (^chooseHouseNatureViewBlock)(NSInteger nature);
@property (nonatomic, copy) void (^houseTextFieldBlock)(NSString* searchText);
@property (assign, nonatomic) BOOL isRefreshDate;
@property (assign, nonatomic) NSInteger natureIndex;

@property (assign, nonatomic) NSInteger searchType;

@property (strong, nonatomic) NSString* searchString;
@end

NS_ASSUME_NONNULL_END
