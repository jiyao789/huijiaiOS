#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyComplaintCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 那个白色背景 View，用来在 XIB 设置圆角
@property (weak, nonatomic) IBOutlet UIView *bgContentView;

@end

NS_ASSUME_NONNULL_END