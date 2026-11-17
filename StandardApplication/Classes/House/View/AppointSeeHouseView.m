//
//  AppointSeeHouseView.m
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "AppointSeeHouseView.h"
#import "PlayPhoneCollectionViewCell.h"
#import "CommitReserveViewController.h"

@interface AppointSeeHouseView ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *textCountLab;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *playPhoneCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *phoneLayout;

@end

@implementation AppointSeeHouseView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _noteTextView.delegate = self;
    _mobileTextField.text = [User shareUser].getMobile;
    
    _playPhoneCollectionView.delegate = self;
    _playPhoneCollectionView.dataSource = self;
    _phoneLayout.minimumLineSpacing = 0;
    _phoneLayout.minimumInteritemSpacing = 0;
    _phoneLayout.itemSize = CGSizeMake(SCREEN_WIDTH - 40, 30);
    [_playPhoneCollectionView registerNib:[UINib nibWithNibName:@"PlayPhoneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PlayPhoneCollectionViewCell"];
}

- (void)setPhoneArr:(NSMutableArray *)phoneArr
{
    _phoneArr = phoneArr;
    [_playPhoneCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _phoneArr.count > 3 ? 3 : _phoneArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayPhoneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayPhoneCollectionViewCell" forIndexPath:indexPath];
    cell.type = 2;
    cell.phoneInfoModel = _phoneArr[indexPath.row];
    return cell;
}

- (void)textViewDidChange:(UITextView *)textView
{
    //字数限制
    if (textView.text.length >= 200) {
        textView.text = [textView.text substringToIndex:200];
    }
    
    if (textView.text.length > 0)  {
        _tipLab.hidden = YES;
        _textCountLab.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)textView.text.length];
    } else {
        _tipLab.hidden = NO;
        _textCountLab.text = @"0/200";
    }
}

- (IBAction)commitBtnClick:(id)sender
{
    if (_nameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入姓名" toView:nil];
        return;
    }
    if (_mobileTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入手机号" toView:nil];
        return;
    }
    if (_mobileTextField.text.length != 11) {
        [MBProgressHUD showMessag:@"请输入正确手机号" toView:nil];
        return;
    }
    [MBProgressHUD showStatus:nil toView:nil];
//  @"book_date":NONullString(_bookDateStr),@"time_slot":NONullString(_timeSlotStr)
    [HttpRequest requestUrlPath:BaseURL urlPath:operate_bookURL parameters:@{@"class":@(_houseClass),@"unit_id":@(_unit_id),@"name":_nameTextField.text,@"phone":_mobileTextField.text,@"note":_noteTextView.text} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissWithView:nil];
        if (status == 1 || status == 2) {
            SAFE_BLOCK(self.didCancelBlock);
        } else {
            [MBProgressHUD showMessag:msg toView:nil];
        }
    }];
}

@end
