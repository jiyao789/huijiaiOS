//
//  AcquisitionProgressView.h
//  StandardApplication
//
//  Progress timeline view for property acquisition declaration
//

#import <UIKit/UIKit.h>

@class AcquisitionProgressItem;

NS_ASSUME_NONNULL_BEGIN

@interface AcquisitionProgressView : UIView

@property (nonatomic, strong) NSArray<AcquisitionProgressItem *> *progressItems;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
