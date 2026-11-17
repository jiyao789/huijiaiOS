//
//  AcquisitionProgressView.m
//  StandardApplication
//
//  Progress timeline view for property acquisition declaration
//

#import "AcquisitionProgressView.h"
#import "AcquisitionProgressModel.h"
#import "Masonry.h"
#import "UIColor+SNFoundation.h"

static const CGFloat kItemHeight = 80;
static const CGFloat kNodeSize = 24;
static const CGFloat kLineWidth = 2;

@interface AcquisitionProgressView ()

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation AcquisitionProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _stackView = [[UIStackView alloc] init];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing = 0;
    [self addSubview:_stackView];

    [_stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(16, 16, 16, 16));
    }];
}

- (void)reloadData {
    // Clear existing views
    for (UIView *view in _stackView.arrangedSubviews) {
        [_stackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    if (_progressItems.count == 0) {
        return;
    }

    for (NSInteger i = 0; i < _progressItems.count; i++) {
        AcquisitionProgressItem *item = _progressItems[i];
        BOOL isLast = (i == _progressItems.count - 1);
        UIView *itemView = [self createItemViewWithItem:item isLast:isLast];
        [_stackView addArrangedSubview:itemView];

        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kItemHeight);
        }];
    }
}

- (UIView *)createItemViewWithItem:(AcquisitionProgressItem *)item isLast:(BOOL)isLast {
    UIView *container = [[UIView alloc] init];

    // Node circle
    UIView *nodeView = [[UIView alloc] init];
    nodeView.layer.cornerRadius = kNodeSize / 2;
    [container addSubview:nodeView];

    // Node icon/label
    UILabel *nodeIcon = [[UILabel alloc] init];
    nodeIcon.textAlignment = NSTextAlignmentCenter;
    nodeIcon.font = [UIFont boldSystemFontOfSize:12];
    nodeIcon.textColor = [UIColor whiteColor];
    [nodeView addSubview:nodeIcon];

    // Configure node based on status
    switch (item.progressStatus) {
        case 1: // Approved
            nodeView.backgroundColor = [UIColor colorWithHexString:@"#34C759"];
            nodeIcon.text = @"✓";
            break;
        case 2: // Rejected
        case 3: // Vetoed
        case 4: // Withdrawn
            nodeView.backgroundColor = [UIColor colorWithHexString:@"#FF3B30"];
            nodeIcon.text = @"✕";
            break;
        default: // Pending
            nodeView.backgroundColor = [UIColor colorWithHexString:@"#FF9500"];
            nodeIcon.text = @"•";
            break;
    }

    // Connecting line (if not last)
    if (!isLast) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [container addSubview:lineView];
        [container sendSubviewToBack:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(nodeView);
            make.top.equalTo(nodeView.mas_bottom);
            make.bottom.equalTo(container);
            make.width.mas_equalTo(kLineWidth);
        }];
    }

    // Title label
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.text = [item getProgressTypeString];
    [container addSubview:titleLabel];

    // Status label
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont systemFontOfSize:13];
    statusLabel.text = [item getProgressStatusString];

    switch (item.progressStatus) {
        case 1:
            statusLabel.textColor = [UIColor colorWithHexString:@"#34C759"];
            break;
        case 2:
        case 3:
            statusLabel.textColor = [UIColor colorWithHexString:@"#FF3B30"];
            break;
        default:
            statusLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            break;
    }
    [container addSubview:statusLabel];

    // Time label
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.text = [item getFormattedTime];
    [container addSubview:timeLabel];

    // Remark label (if any)
    UILabel *remarkLabel = [[UILabel alloc] init];
    remarkLabel.font = [UIFont systemFontOfSize:12];
    remarkLabel.textColor = [UIColor colorWithHexString:@"#FF3B30"];
    remarkLabel.numberOfLines = 0;
    if (item.remark.length > 0) {
        remarkLabel.text = item.remark;
    }
    [container addSubview:remarkLabel];

    // Layout
    [nodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container);
        make.top.equalTo(container);
        make.width.height.mas_equalTo(kNodeSize);
    }];

    [nodeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(nodeView);
    }];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nodeView.mas_right).offset(12);
        make.top.equalTo(container).offset(2);
    }];

    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(8);
        make.centerY.equalTo(titleLabel);
    }];

    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(6);
    }];

    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(container).offset(-16);
        make.top.equalTo(timeLabel.mas_bottom).offset(4);
    }];

    return container;
}

@end
