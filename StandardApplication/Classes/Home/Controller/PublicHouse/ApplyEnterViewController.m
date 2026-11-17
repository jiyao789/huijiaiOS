//
//  ApplyEnterViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ApplyEnterViewController.h"
#import "MacroDefine.h"


@interface ApplyEnterViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (nonatomic, strong) UIButton *progressQueryBtn;
@property (nonatomic, strong) NSArray *downloadUrlArr;
@end

@implementation ApplyEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _viewLayoutTop.constant = NAVBAR_HEIGHT;
    
    [self leftBarItem];
    self.navTitle = @"资格申请入口";
    
    _downloadUrlArr = @[@"https://alpha.huichenghuijia.com/fixed/2021上海市公共租赁住房申请表_空白版.docx",@"https://alpha.huichenghuijia.com/fixed/单身承诺书.docx"];
}

- (IBAction)downloadBtnClick:(UIButton *)sender
{
    // 跳到浏览器web页面
    NSString *url = _downloadUrlArr[sender.tag];
    if ([CommonUtils isHasChineseWithStr:url] || [url containsString:@">"] || [url containsString:@" "] || [url containsString:@"?"]) {
        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}


@end
