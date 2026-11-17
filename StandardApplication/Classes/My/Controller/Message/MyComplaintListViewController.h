#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyComplaintListViewController : BaseViewController

// 必须在这里声明，.m 文件才能通过 self.xxx 访问到
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;

@end

NS_ASSUME_NONNULL_END