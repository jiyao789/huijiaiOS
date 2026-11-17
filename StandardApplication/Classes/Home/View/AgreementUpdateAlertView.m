//
//  AgreementUpdateAlertView.m
//  StandardApplication
//
//  Created on 2026/11/17.
//  Copyright © 2026 DTiOS. All rights reserved.
//

#import "AgreementUpdateAlertView.h"
#import "MacroDefine.h"

@interface AgreementUpdateAlertView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation AgreementUpdateAlertView

+ (instancetype)alertView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, 310, 210)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 20.0f;
    self.layer.masksToBounds = YES;

    CGFloat cardWidth = self.bounds.size.width > 0 ? self.bounds.size.width : 310;
    CGFloat paddingX = 22.0f;
    CGFloat contentWidth = cardWidth - paddingX * 2;

    // 1. 粗体单行居中标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(paddingX, 26, contentWidth, 25)];
    _titleLabel.text = @"隐私政策与用户协议更新提醒";
    _titleLabel.textColor = [UIColor colorWithHexString:@"#1A1A1A"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];

    // 2. 带下划线可点击的蓝色协议富文本
    NSString *plainText = @"我们的《隐私政策》和《用户协议》已更新，请前往查看。";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:plainText];

    UIFont *contentFont = [UIFont systemFontOfSize:14.0f];
    UIColor *textColor = [UIColor colorWithHexString:@"#333333"];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5.0f;
    paraStyle.alignment = NSTextAlignmentLeft;

    [attrStr addAttributes:@{
        NSFontAttributeName: contentFont,
        NSForegroundColorAttributeName: textColor,
        NSParagraphStyleAttributeName: paraStyle
    } range:NSMakeRange(0, plainText.length)];

    NSRange privacyRange = [plainText rangeOfString:@"《隐私政策》"];
    if (privacyRange.location != NSNotFound) {
        [attrStr addAttribute:NSLinkAttributeName value:@"agreement://privacy" range:privacyRange];
    }

    NSRange userAgreementRange = [plainText rangeOfString:@"《用户协议》"];
    if (userAgreementRange.location != NSNotFound) {
        [attrStr addAttribute:NSLinkAttributeName value:@"agreement://user" range:userAgreementRange];
    }

    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(paddingX, CGRectGetMaxY(_titleLabel.frame) + 16, contentWidth, 48)];
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.editable = NO;
    _contentTextView.scrollEnabled = NO;
    _contentTextView.textContainerInset = UIEdgeInsetsZero;
    _contentTextView.textContainer.lineFragmentPadding = 0;
    _contentTextView.attributedText = attrStr;
    _contentTextView.linkTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#2C6DB0"],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
    };
    _contentTextView.delegate = self;
    [self addSubview:_contentTextView];

    // 3. 棕金色圆角大按钮
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(paddingX, CGRectGetMaxY(_contentTextView.frame) + 24, contentWidth, 44);
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#BA9462"];
    _confirmBtn.layer.cornerRadius = 22.0f;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmBtn];

    CGFloat totalHeight = CGRectGetMaxY(_confirmBtn.frame) + 24;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, cardWidth, totalHeight);
}

- (void)confirmBtnClick {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([URL.scheme isEqualToString:@"agreement"]) {
        if ([URL.host isEqualToString:@"privacy"]) {
            if (self.privacyClickBlock) {
                self.privacyClickBlock();
            }
            return NO;
        } else if ([URL.host isEqualToString:@"user"]) {
            if (self.userAgreementClickBlock) {
                self.userAgreementClickBlock();
            }
            return NO;
        }
    }
    return YES;
}

@end
