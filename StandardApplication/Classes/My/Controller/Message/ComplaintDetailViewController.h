#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComplaintDetailViewController : BaseViewController

/** 投诉 ID，由列表页传入 */
@property (nonatomic, copy) NSString *complaintId;

@end

NS_ASSUME_NONNULL_END