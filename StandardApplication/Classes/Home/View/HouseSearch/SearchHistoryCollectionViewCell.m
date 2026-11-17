//
//  SearchHistoryCollectionViewCell.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SearchHistoryCollectionViewCell.h"
#import "MacroDefine.h"

@implementation SearchHistoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)deleteBtnClick:(id)sender
{
    SAFE_BLOCK(self.removeIndexButtonBlock,self.historySearchLab.text);
}


@end
