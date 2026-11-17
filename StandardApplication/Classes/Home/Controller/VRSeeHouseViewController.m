//
//  VRSeeHouseViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2022/11/7.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "VRSeeHouseViewController.h"
#import "MacroDefine.h"
#import "ProtocolBaseWKWebViewController.h"

@interface VRSeeHouseViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayoutTop;
@property (weak, nonatomic) IBOutlet UIImageView *vrImageViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *vrImageViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *vrImageViewThree;

@end

@implementation VRSeeHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"VR实景看房";
    
    _bgViewLayoutTop.constant = NAVBAR_HEIGHT + 16;
    
    KWeakSelf
    [_vrImageViewOne whenTapped:^{
        [weakSelf pushWKWebViewInfo:@"https://kuaixiu.huichenghuijia.com/lnjy/?scene_id=84985747" title:@"龙南佳苑"];//（龙南佳苑）
    }];
    [_vrImageViewTwo whenTapped:^{
        [weakSelf pushWKWebViewInfo:@"https://kuaixiu.huichenghuijia.com/wyf/?scene_id=84985858" title:@"五月苑"];//（五月苑）
    }];
    [_vrImageViewThree whenTapped:^{
        [weakSelf pushWKWebViewInfo:@"https://kuaixiu.huichenghuijia.com/jy/?scene_id=84984539" title:@"嘉园"];//（嘉园）
    }];
}

- (void)pushWKWebViewInfo:(NSString *)webUrl title:(NSString *)name
{
    ProtocolBaseWKWebViewController *vc = [ProtocolBaseWKWebViewController new];
    vc.webUrl = webUrl;
    vc.webTitle = name;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
