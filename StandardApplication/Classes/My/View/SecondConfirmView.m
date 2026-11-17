//
//  SecondConfirmView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/24.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SecondConfirmView.h"

@implementation SecondConfirmView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)cancelBtnClick:(id)sender
{
    SAFE_BLOCK(self.didCancelBlock);
}

- (IBAction)confirmBtnClick:(id)sender
{
    SAFE_BLOCK(self.didConfirmBlock);
}

@end
