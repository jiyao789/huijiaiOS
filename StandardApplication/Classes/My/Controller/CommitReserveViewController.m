//
//  CommitReserveViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CommitReserveViewController.h"
#import "MacroDefine.h"

@interface CommitReserveViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UIImageView *successImageView;
@property (weak, nonatomic) IBOutlet UILabel *showMsgView;

@end

@implementation CommitReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
    self.gk_interactivePopDisabled = YES;
    
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 60;

    switch (_successType) {
        case PaySuccessType:
        {
            self.navTitle = @"支付成功";
            _showMsgView.text = @"支付成功～";
            _successImageView.image = [UIImage imageNamed:@"pay_success_img"];
            break;
        }
        case RechargeSuccessType:
        {
            self.navTitle = @"充值成功";
            _showMsgView.text = @"充值成功～";
            _successImageView.image = [UIImage imageNamed:@"recharge_success_img"];
            break;
        }
        case ReserrveSuccessType:
        {
            self.navTitle = @"预约成功";
            _showMsgView.text = @"您好！您的看房预约已提交\n稍后，我们会有专人为您安排具体看房事宜\n请您耐心等待";
            _successImageView.image = [UIImage imageNamed:@"reserrve_success_img"];
            break;
        }
        case EntrustSuccessType:
        {
            self.navTitle = @"完成提交";
            _showMsgView.text = @"您已成功提交委托，稍后会有工作人员与\n您联系，请保持手机畅通！";
            _successImageView.image = [UIImage imageNamed:@"commit_success_img"];
            break;
        }
        case OwnerWantSuccessType:
        {
            self.navTitle = @"完成提交";
            _showMsgView.text =
            @"您已成功提交申请，请保持手机畅通，\n之后将会有管家联系您。";
            _successImageView.image = [UIImage imageNamed:@"commit_success_img"];
            break;
        }
        case ContinueReatSuccessType:
        {
            self.navTitle = @"续租成功";
            _showMsgView.text = @"您已成功提交续租申请\n请耐心等待工作人员与您联系";
            _successImageView.image = [UIImage imageNamed:@"continue_reat_success_img"];
            break;
        }
        case SurrenderReatSuccess:
        {
            self.navTitle = @"退租成功";
            _showMsgView.text = @"退租成功～";
            _successImageView.image = [UIImage imageNamed:@"surrender_reat_success_img"];
            break;
        }
        case CommitFinishSuccessType:
        {
            self.navTitle = @"投诉成功";
            _showMsgView.text = @"我们已经收到您的投诉\n相关工作人员会尽早联系您，请保持电话联系";
            _successImageView.image = [UIImage imageNamed:@"cancel_reserve_img"];
            break;
        }
        default:
            break;
    }
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backHomeBtnClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
