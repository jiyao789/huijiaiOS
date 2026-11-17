//
//  SearchNaviView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "SearchNaviView.h"

@implementation SearchNaviView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _searchView.cornerRadiu = 12;
    _searchBackBtn.imagePosition = QMUIButtonImagePositionTop;
    _searchBackBtn.spacingBetweenImageAndTitle = 2;
    
    _searchTextField.delegate = self;
}

- (IBAction)textFieldEditChanged:(id)sender
{
    if (_searchTextField.text.length == 0) {
        SAFE_BLOCK(self.searchNaviTextFieldBlock);
    }
}

- (IBAction)searchBtnClick:(id)sender
{
    if (IsStrEmpty(_searchTextField.text)) {
        [MBProgressHUD showMessag:@"请输入" toView:nil];
        return;
    }
    [_searchTextField resignFirstResponder];
    SAFE_BLOCK(self.searchNaviButtonBlock,self.searchTextField.text);
    dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
        [[SNFileCache defaultCache] saveDictionary:_searchTextField.text forKey:@"Search"];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (IsStrEmpty(_searchTextField.text)) {
        [MBProgressHUD showMessag:@"请输入" toView:nil];
        return NO;
    }
    [_searchTextField resignFirstResponder];
    SAFE_BLOCK(self.searchNaviButtonBlock,self.searchTextField.text);
    
    dispatch_async(dispatch_queue_create("com.wdit.hzapp", DISPATCH_QUEUE_SERIAL), ^{
        [[SNFileCache defaultCache] saveDictionary:_searchTextField.text forKey:@"Search"];
    });
    
    return YES;
}

- (IBAction)searchBackBtnClick:(id)sender
{
    [[CommonUtils getCurrentViewController].navigationController popViewControllerAnimated:YES];
}

@end
