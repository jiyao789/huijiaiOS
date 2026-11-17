//
//  OwnerWantViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2022/4/24.
//  Copyright © 2022 DTiOS. All rights reserved.
//

#import "OwnerWantViewController.h"
#import "MacroDefine.h"
#import "UserModel.h"
#import "WSDatePickerView.h"
#import "RoomTypeCollectionViewCell.h"
#import "CommitReserveViewController.h"
#import "UserModel.h"

@interface OwnerWantViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *rentTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *roomTypeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *roomTypeLayout;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@property (strong, nonatomic) NSArray *roomTypeArr;
@property (strong, nonatomic) NSMutableArray *roomTypeTitleArr;
@property (strong, nonatomic) NSMutableArray *roomTypeIndexArr;
@property (strong, nonatomic) UserModel *userModel;
@end

@implementation OwnerWantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hideNaviBar = YES;
    self.view.backgroundColor = [UIColor clearColor];
    _roomTypeArr = @[@"一居室",@"二居室",@"三居室",@"LOFT",@"单身公寓"];
    _noteTextField.delegate = self;
    _enterTextField.text = [NSDate getNowDateStr];

    [self getUserDateInfo];
    
    [self setControllerInfo];
}

- (void)setControllerInfo
{
    _roomTypeCollectionView.delegate = self;
    _roomTypeCollectionView.dataSource = self;
    _roomTypeLayout.minimumLineSpacing = 10;
    _roomTypeLayout.minimumInteritemSpacing = (SCREEN_WIDTH - 86 - 62 * 4) / 3;
    _roomTypeLayout.itemSize = CGSizeMake(62, 25);
    [_roomTypeCollectionView registerNib:[UINib nibWithNibName:@"RoomTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RoomTypeCollectionViewCell"];
    
    KWeakSelf
    [_enterTextField whenTapped:^{
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
            NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
            NSLog(@"选择的日期：%@",dateString);
            weakSelf.enterTextField.text = dateString;
        }];
        datepicker.minLimitDate = [NSDate date];
        datepicker.dateLabelColor = [UIColor colorWithHex:@"#202224"];//年-月-日-时-分 颜色
        datepicker.datePickerColor = [UIColor colorWithHex:@"#202224"];//滚轮日期颜色
        [datepicker show];
    }];
}

- (void)getUserDateInfo
{
    [HttpRequest requestUrlPath:BaseURL urlPath:setting_profileURL parameters:@{} type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        if (status == 1) {
            self.userModel = [UserModel mj_objectWithKeyValues:dic];
            self.nameTextField.text = NONullString(self.userModel.name);
            self.mobileTextField.text = NONullString(self.userModel.phone);
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}

- (void)textFieldDidChangeSelection:(UITextField *)textField
{
    //字数限制
    if (_noteTextField.text.length >= 50) {
        _noteTextField.text = [_noteTextField.text substringToIndex:50];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _roomTypeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoomTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RoomTypeCollectionViewCell" forIndexPath:indexPath];
    NSString *titleStr = NONullString(_roomTypeArr[indexPath.row]);
    cell.titleLab.text = titleStr;
    BOOL isHave = NO;
    for (NSString *key in self.roomTypeTitleArr) {
        if ([key isEqualToString:titleStr]) {
            isHave = YES;
            break;
        }
    }
    cell.titleLab.backgroundColor = isHave ? [UIColor colorWithHexString:@"#1B61A0"] : [UIColor colorWithHexString:@"#E2EBF0"];
    cell.titleLab.textColor = isHave ? [UIColor whiteColor] : [UIColor colorWithHexString:@"#9BA6AC"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr = NONullString(_roomTypeArr[indexPath.row]);
    BOOL isHave = NO;
    for (NSString *key in self.roomTypeTitleArr) {
        if ([key isEqualToString:titleStr]) {
            isHave = YES;
            break;
        }
    }
    if (isHave) {
        [self.roomTypeTitleArr removeObject:titleStr];
        [self.roomTypeIndexArr removeObject:[NSString stringWithFormat:@"%ld",(long)(indexPath.row + 1)]];
    } else {
        [self.roomTypeTitleArr addObject:titleStr];
        [self.roomTypeIndexArr addObject:[NSString stringWithFormat:@"%ld",(long)(indexPath.row + 1)]];
    }
    [_roomTypeCollectionView reloadData];
}

- (IBAction)commitBtnClick:(id)sender
{
    if (_nameTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入姓名" toView:self.view];
        return;
    }
    if (_mobileTextField.text.length == 0) {
        [MBProgressHUD showMessag:@"请输入手机号" toView:self.view];
        return;
    }
    if (_mobileTextField.text.length != 11) {
        [MBProgressHUD showMessag:@"请输入正确手机号" toView:nil];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:NONullString(_mobileTextField.text) forKey:@"phone"];
    [para setObject:NONullString(_nameTextField.text) forKey:@"name"];
    [para setObject:NONullString(_noteTextField.text) forKey:@"note"];
    [para setObject:NONullString(_enterTextField.text) forKey:@"check_time"];
    [para setObject:[NSString stringWithFormat:@"%ld",[_rentTextField.text integerValue] * 100] forKey:@"rent"];
    if (_roomTypeIndexArr.count > 0) {
        [para setObject:[_roomTypeIndexArr mj_JSONString] forKey:@"room_type"];
    } else {
        [para setObject:@[] forKey:@"room_type"];
    }
    [MBProgressHUD showStatus:nil toView:self.view];
    [HttpRequest requestUrlPath:BaseURL urlPath:unit_wantedURL parameters:para type:HttpRequestTypePost result:^(NSDictionary * _Nonnull dic, NSInteger status, NSString * _Nonnull msg) {
        [MBProgressHUD dismissHUDForView:self.view];
        if (status == 1 || status == 2) {
            self.nameTextField.text = NONullString(self.userModel.name);
            self.mobileTextField.text = NONullString(self.userModel.phone);
            self.rentTextField.text = @"";
            self.enterTextField.text = [NSDate getNowDateStr];
            self.noteTextField.text = @"";
            [self.roomTypeTitleArr removeAllObjects];
            [self.roomTypeIndexArr removeAllObjects];
            [self.roomTypeCollectionView reloadData];
            CommitReserveViewController *vc = [CommitReserveViewController new];
            vc.successType = OwnerWantSuccessType;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showMessag:msg toView:self.view];
        }
    }];
}


- (NSMutableArray *)roomTypeTitleArr
{
    if (!_roomTypeTitleArr) {
        _roomTypeTitleArr = [NSMutableArray array];
    }
    return _roomTypeTitleArr;
}

- (NSMutableArray *)roomTypeIndexArr
{
    if (!_roomTypeIndexArr) {
        _roomTypeIndexArr = [NSMutableArray array];
    }
    return _roomTypeIndexArr;
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
