//
//  RegisterGuideVC.m
//  StandardApplication
//
//  不动产登记簿查询指引页面
//

#import "RegisterGuideVC.h"
#import "MacroDefine.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RegisterGuideVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;

@end

@implementation RegisterGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self leftBarItem];
    self.navTitle = @"不动产登记簿查询指引";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupImageUrls];
    [self setupUI];
}

- (void)setupImageUrls {
    _imageUrls = @[
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide1.jpg", // 图片1
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide2.jpg", // 图片2
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide3.jpg", // 图片3
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide4.jpg", // 图片4
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide5.jpg", // 图片5
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide6.jpg", // 图片6
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide7.jpg", // 图片7
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide8.jpg", // 图片8
        @"https://huihome.oss-cn-shanghai.aliyuncs.com/huijia_app/register_guide/register_guide9.jpg", // 图片9
    ];
}

- (void)setupUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_scrollView];

    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_contentView];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    }];

    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];

    CGFloat imageSpacing = 8; // 图片之间的间距
    CGFloat horizontalPadding = 0; // 左右边距
    CGFloat imageWidth = SCREEN_WIDTH - horizontalPadding * 2;

    UIView *lastView = nil;

    for (NSInteger i = 0; i < _imageUrls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        imageView.clipsToBounds = YES;
        [_contentView addSubview:imageView];

        NSString *url = _imageUrls[i];
        if (url.length > 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        }

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentView).offset(horizontalPadding);
            make.right.equalTo(_contentView).offset(-horizontalPadding);
            // 假设图片宽高比约为 3:4，可根据实际情况调整
            make.height.mas_equalTo(imageWidth * 4 / 3);

            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(imageSpacing);
            } else {
                make.top.equalTo(_contentView).offset(16);
            }
        }];

        lastView = imageView;
    }

    // 设置contentView底部约束
    if (lastView) {
        [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_contentView).offset(-20);
        }];
    }
}

@end
