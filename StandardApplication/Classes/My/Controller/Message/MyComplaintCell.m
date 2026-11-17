#import "MyComplaintCell.h"

@implementation MyComplaintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 这里可以做一些额外的初始化
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end