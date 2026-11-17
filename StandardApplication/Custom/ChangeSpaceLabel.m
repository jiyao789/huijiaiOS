//
//  ChangeSpaceLabel.m
//  EnjoyOilBao
//
//  Created by yiye on 2018/12/8.
//  Copyright © 2018 yiye. All rights reserved.
//

#import "ChangeSpaceLabel.h"

@implementation ChangeSpaceLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
        [self setAttributedText:setString];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
        [self setAttributedText:setString];
    }
    return self;
}


@end
