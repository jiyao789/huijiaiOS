//
//  AcquisitionListItemModel.h
//  StandardApplication
//
//  Property acquisition declaration list item model
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AcquisitionListItemModel : NSObject

/// Declaration ID
@property (nonatomic, assign) NSInteger itemId;
/// Declaration number
@property (nonatomic, copy) NSString *bh;
/// Declaration time
@property (nonatomic, copy) NSString *declareTime;
/// Full address
@property (nonatomic, copy) NSString *address;
/// Status: 0-Pending, 1-Approved, 2-Rejected, 3-Vetoed
@property (nonatomic, assign) NSInteger status;
/// Progress: 1-Initial Review, 2-Final Review, 3-Completed
@property (nonatomic, assign) NSInteger progress;

@end

NS_ASSUME_NONNULL_END
