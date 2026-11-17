//
//  PublicApplyTestViewController.m
//  StandardApplication
//
//  Created by DTiOS on 2021/10/23.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "PublicApplyTestViewController.h"
#import "MacroDefine.h"
#import "QuestionModel.h"

@interface PublicApplyTestViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLayoutTop;
@property (weak, nonatomic) IBOutlet UILabel *questionLab;

@property (weak, nonatomic) IBOutlet BaseShadowView *selectAView;
@property (weak, nonatomic) IBOutlet UILabel *answerALab;
@property (weak, nonatomic) IBOutlet UILabel *showTypeALab;

@property (weak, nonatomic) IBOutlet BaseShadowView *selectBView;
@property (weak, nonatomic) IBOutlet UILabel *answerBLab;
@property (weak, nonatomic) IBOutlet UILabel *showTypeBLab;
@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstNextBtn;

@property (strong, nonatomic) NSArray *questionArr;
@property (assign, nonatomic) NSInteger questionCount;
@property (strong, nonatomic) NSMutableArray *answerArr;
@end

@implementation PublicApplyTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftBarItem];
    self.navTitle = @"公租房资格测试";
    self.imageLayoutTop.constant = NAVBAR_HEIGHT;
    
    _questionCount = 0;
    NSArray *arr = [CommonUtils getJsonObjectFromLocal:@"question.json"];
    _questionArr = [QuestionModel mj_objectArrayWithKeyValuesArray:arr];
    _previousBtn.hidden = YES;
    _nextBtn.hidden = YES;
    _firstNextBtn.hidden = NO;
    [self setQuestionInfo];
    
    KWeakSelf
    [_selectAView whenTapped:^{
        [weakSelf setASelectAnswerInfo];
        QuestionModel *model = weakSelf.questionArr[_questionCount];
        model.select = @"A";
    }];
    
    [_selectBView whenTapped:^{
        [weakSelf setBSelectAnswerInfo];
        QuestionModel *model = weakSelf.questionArr[_questionCount];
        model.select = @"B";
    }];
}

- (IBAction)previousBtnClick:(id)sender
{
    _questionCount --;
    [self setQuestionInfo];
    if (_questionCount == 0) {
        _previousBtn.hidden = YES;
        _nextBtn.hidden = YES;
        _firstNextBtn.hidden = NO;
        [_firstNextBtn setTitle:@"下一题" forState:UIControlStateNormal];
    }
}

- (IBAction)nextBtnClick:(id)sender
{
    QuestionModel *model = _questionArr[_questionCount];
    if (IsStrEmpty(model.select)) {
        [MBProgressHUD showMessag:@"请选择选项" toView:self.view];
        return;
    }
    if (_questionCount == _questionArr.count - 1) {
        NSString *commitMsg = @"恭喜你，资格测试通过";
        for (QuestionModel *questionModel in _questionArr) {
            if ([questionModel.select isEqualToString:@"B"]) {
                commitMsg = @"很遗憾，资格测试不通过";
            }
        }
        [MBProgressHUD showMessag:commitMsg toView:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    _questionCount ++;
    [self setQuestionInfo];
    if (_questionCount == _questionArr.count - 1) {
        [_nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
}

- (IBAction)firstNextBtnClick:(id)sender
{
    QuestionModel *model = _questionArr[_questionCount];
    if (IsStrEmpty(model.select)) {
        [MBProgressHUD showMessag:@"请选择选项" toView:self.view];
        return;
    }
    _questionCount ++;
    [self setQuestionInfo];
    _previousBtn.hidden = NO;
    _nextBtn.hidden = NO;
    _firstNextBtn.hidden = YES;
    if (_questionCount == _questionArr.count - 1) {
        [_nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
}

- (void)setQuestionInfo
{
    QuestionModel *model = _questionArr[_questionCount];
    _questionLab.text = NONullString(model.question);
    _answerALab.text = NONullString(model.answerA);
    _answerBLab.text = NONullString(model.answerB);
    if (IsStrEmpty(model.select)) {
        [self setUnSelectAnswerInfo];
    } else if ([model.select isEqualToString:@"A"]) {
        [self setASelectAnswerInfo];
    } else if ([model.select isEqualToString:@"B"]) {
        [self setBSelectAnswerInfo];
    }
}

- (void)setASelectAnswerInfo
{
    self.answerALab.layer.borderWidth = 1;
    self.answerALab.layer.borderColor = [UIColor colorWithHexString:@"#BCA462"].CGColor;
    self.answerALab.textColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    self.showTypeALab.backgroundColor = [UIColor colorWithHexString:@"#BCA462"];
    self.showTypeALab.textColor = [UIColor whiteColor];
    
    self.answerBLab.layer.borderWidth = 1;
    self.answerBLab.layer.borderColor = [UIColor whiteColor].CGColor;
    self.answerBLab.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    self.showTypeBLab.backgroundColor = [UIColor whiteColor];
    self.showTypeBLab.textColor = [UIColor colorWithHexString:@"#2C6DB0"];
}

- (void)setBSelectAnswerInfo
{
    self.answerBLab.layer.borderWidth = 1;
    self.answerBLab.layer.borderColor = [UIColor colorWithHexString:@"#BCA462"].CGColor;
    self.answerBLab.textColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
    self.showTypeBLab.backgroundColor = [UIColor colorWithHexString:@"#BCA462"];
    self.showTypeBLab.textColor = [UIColor whiteColor];
    
    self.answerALab.layer.borderWidth = 1;
    self.answerALab.layer.borderColor = [UIColor whiteColor].CGColor;
    self.answerALab.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    self.showTypeALab.backgroundColor = [UIColor whiteColor];
    self.showTypeALab.textColor = [UIColor colorWithHexString:@"#2C6DB0"];
}

- (void)setUnSelectAnswerInfo
{
    self.answerALab.layer.borderWidth = 1;
    self.answerALab.layer.borderColor = [UIColor whiteColor].CGColor;
    self.answerALab.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    self.showTypeALab.backgroundColor = [UIColor whiteColor];
    self.showTypeALab.textColor = [UIColor colorWithHexString:@"#2C6DB0"];
    
    self.answerBLab.layer.borderWidth = 1;
    self.answerBLab.layer.borderColor = [UIColor whiteColor].CGColor;
    self.answerBLab.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    self.showTypeBLab.backgroundColor = [UIColor whiteColor];
    self.showTypeBLab.textColor = [UIColor colorWithHexString:@"#2C6DB0"];
    
}

- (NSMutableArray *)answerArr
{
    if (!_answerArr) {
        _answerArr = [NSMutableArray array];
    }
    return _answerArr;
}

@end
