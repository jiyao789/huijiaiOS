//
//  AcquisitionListCell.m
//  StandardApplication
//
//  Property acquisition declaration list cell - Matching prototype design
//

#import "AcquisitionListCell.h"
#import "AcquisitionListItemModel.h"
#import "Masonry.h"
#import "UIColor+SNFoundation.h"

#define kAcqGreenColor        [UIColor colorWithHexString:@"#2A629A"]
#define kAcqTextPrimary       [UIColor colorWithHexString:@"#333333"]
#define kAcqTextSecondary     [UIColor colorWithHexString:@"#666666"]
#define kAcqTextHint          [UIColor colorWithHexString:@"#999999"]
#define kAcqDivider           [UIColor colorWithHexString:@"#EEEEEE"]

@interface AcquisitionListCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIView *dividerLine;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation AcquisitionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // Card view
    _cardView = [[UIView alloc] init];
    _cardView.backgroundColor = [UIColor whiteColor];
    _cardView.layer.cornerRadius = 8;
    [self.contentView addSubview:_cardView];

    // Title label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = kAcqTextPrimary;
    _titleLabel.text = @"房源收购意向申报";
    [_cardView addSubview:_titleLabel];

    // Detail button
    _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailButton setTitle:@"查看详情 >" forState:UIControlStateNormal];
    [_detailButton setTitleColor:kAcqGreenColor forState:UIControlStateNormal];
    _detailButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _detailButton.userInteractionEnabled = NO;
    [_cardView addSubview:_detailButton];

    // Divider line
    _dividerLine = [[UIView alloc] init];
    _dividerLine.backgroundColor = kAcqDivider;
    [_cardView addSubview:_dividerLine];

    // Code label
    _codeLabel = [[UILabel alloc] init];
    _codeLabel.font = [UIFont systemFontOfSize:14];
    _codeLabel.textColor = kAcqTextSecondary;
    [_cardView addSubview:_codeLabel];

    // Time label
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = kAcqTextSecondary;
    [_cardView addSubview:_timeLabel];

    // Layout
    [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cardView).offset(16);
        make.top.equalTo(_cardView).offset(16);
    }];

    [_detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_cardView).offset(-16);
        make.centerY.equalTo(_titleLabel);
    }];

    [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cardView).offset(16);
        make.right.equalTo(_cardView).offset(-16);
        make.top.equalTo(_titleLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(0.5);
    }];

    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cardView).offset(16);
        make.top.equalTo(_dividerLine.mas_bottom).offset(12);
    }];

    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cardView).offset(16);
        make.top.equalTo(_codeLabel.mas_bottom).offset(8);
        make.bottom.equalTo(_cardView).offset(-16);
    }];
}

- (void)setModel:(AcquisitionListItemModel *)model {
    _model = model;

    _codeLabel.text = [NSString stringWithFormat:@"意向编码：%@", model.bh ?: @""];
    _timeLabel.text = [NSString stringWithFormat:@"申报时间：%@", model.declareTime ?: @""];
}

+ (CGFloat)cellHeight {
    return 130;
}

@end
