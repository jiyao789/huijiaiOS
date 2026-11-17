//
//  VersionUpdateView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/9.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "VersionUpdateView.h"

@implementation VersionUpdateView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setVersionDic:(NSDictionary *)versionDic
{
    _versionDic = versionDic;
    if ([_versionDic[@"forced_update"] integerValue] == 2) {
        _forcedUpdateBtn.hidden = NO;
        _updateBtn.hidden = YES;
        _cancelBtn.hidden = YES;
    } else {
        _forcedUpdateBtn.hidden = YES;
        _updateBtn.hidden = NO;
        _cancelBtn.hidden = NO;
    }
    _versionNumberLab.text = [NSString stringWithFormat:@"V%@",_versionDic[@"version_sn"]];
    _versionInfoLab.text = [NSString stringWithFormat:@"%@",_versionDic[@"priority"]];
}

- (IBAction)updateBtnClick:(id)sender
{
    SAFE_BLOCK(self.didConfirmBlock);
}

- (IBAction)cancelBtnClick:(id)sender
{
    SAFE_BLOCK(self.didCancelBlock);
}

@end
