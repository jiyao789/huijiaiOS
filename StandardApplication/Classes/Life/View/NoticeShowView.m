//
//  NoticeShowView.m
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "NoticeShowView.h"

@implementation NoticeShowView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)backBtnClick:(id)sender
{
    SAFE_BLOCK(self.didCancelBlock);
}


@end
