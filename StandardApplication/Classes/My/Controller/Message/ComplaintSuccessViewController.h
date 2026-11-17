#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComplaintSuccessViewController : BaseViewController

// 预留一个投诉ID，方便以后详情页跳转
@property (nonatomic, copy) NSString *complaintId;

@end

NS_ASSUME_NONNULL_END