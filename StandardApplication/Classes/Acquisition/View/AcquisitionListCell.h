//
//  AcquisitionListCell.h
//  StandardApplication
//
//  Property acquisition declaration list cell
//

#import <UIKit/UIKit.h>

@class AcquisitionListItemModel;

NS_ASSUME_NONNULL_BEGIN

@interface AcquisitionListCell : UITableViewCell

@property (nonatomic, strong) AcquisitionListItemModel *model;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
