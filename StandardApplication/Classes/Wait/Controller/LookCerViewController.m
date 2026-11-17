//
//  LookCerViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2023/6/30.
//  Copyright © 2023 DTiOS. All rights reserved.
//

#import "LookCerViewController.h"
#import "MacroDefine.h"

@interface LookCerViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutTop;
@property (weak, nonatomic) IBOutlet UIImageView *cerImageView;

@end

@implementation LookCerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"查看资格证书";
    _viewLayoutTop.constant = NAVBAR_HEIGHT + 16;
    
    _cerImageView.image = [UIImage imageNamed:_type == 1 ? @"cer_number_image.png" : @"cer_data_image.png"];
}


@end
