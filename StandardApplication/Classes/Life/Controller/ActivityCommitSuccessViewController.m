//
//  ActivityCommitSuccessViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/8.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ActivityCommitSuccessViewController.h"
#import "MacroDefine.h"

@interface ActivityCommitSuccessViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutHeight;
@property (weak, nonatomic) IBOutlet UIView *showView;


@end

@implementation ActivityCommitSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"预约成功";
    self.gk_interactivePopDisabled = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FE"];
    
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 60;
    
    if (_type == 2) {
        _showView.hidden = YES;
        _viewLayoutHeight.constant = 0;
        _nameLab.text = NONullString(_activityListModel.title);
        _timeLab.text = [NSString stringWithFormat:@"%@ %@-%@",_activityListModel.date,_activityListModel.start_time,_activityListModel.end_time];
        _peopleLab.text = NONullString(_activityListModel.name);
        _mobileLab.text = NONullString(_activityListModel.phone);
    } else if (_type == 1) {
        _showView.hidden = NO;
        _viewLayoutHeight.constant = 70;
        _nameLab.text = NONullString(_spaceDetailModel.space_name);
        _timeLab.text = [NSString stringWithFormat:@"%@ %@-%@",_spaceSelectTime,_spaceDetailModel.start_opening_hours,_spaceDetailModel.end_opening_hours];
        _peopleLab.text = NONullString(_spaceDetailModel.user_info.name);
        _mobileLab.text = NONullString(_spaceDetailModel.user_info.phone);
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
