//
//  MBProgressHUD+YBDownload.m
//  StandardApplication
//
//  Created by liyuanbo on 2019/11/22.
//  Copyright © 2019 DTiOS. All rights reserved.
//

#import "MBProgressHUD+YBDownload.h"
#import "MacroDefine.h"

static CGFloat const customViewWidthHeight = 44;
@interface MBProgressHUDCustomView : UIView

@property (nonatomic, assign) float progress;

@end

@implementation MBProgressHUDCustomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //圆环
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, 1, 1)];
    [bezierPath setLineWidth:2];
    [[[UIColor whiteColor] colorWithAlphaComponent:0.2f] setStroke];
    [bezierPath stroke];
    
    //进度条
    UIBezierPath * bezierPathArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:rect.size.width / 2 - 1 startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI * 2 * self.progress clockwise:YES];
    [bezierPathArc setLineWidth:2];
    [[UIColor whiteColor] setStroke];
    [bezierPathArc stroke];
    
    //文字
    NSString * progressText = [NSString stringWithFormat:@"%.0f%%",self.progress * 100];
    UIFont * font = [UIFont systemFontOfSize:12];
    NSDictionary * attributes = @{NSFontAttributeName: font,NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize size = [progressText boundingRectWithSize:CGSizeMake(customViewWidthHeight, customViewWidthHeight) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    [progressText drawAtPoint:CGPointMake(rect.size.width / 2 - size.width / 2, rect.size.height / 2 - size.height / 2)withAttributes:attributes];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(customViewWidthHeight, customViewWidthHeight);
}

@end

@implementation MBProgressHUD (YBDownload)

+ (MBProgressHUD *)showDownloadHudAddTo:(UIView *)view animated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.defaultMotionEffectsEnabled = NO;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    hud.backgroundColor = [UIColor clearColor];
    hud.backgroundView.color = [UIColor clearColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.minSize = CGSizeMake(120, 120);
//    hud.backgroundView.userInteractionEnabled = NO;
    
    MBProgressHUDCustomView * customView = [[MBProgressHUDCustomView alloc] init];
    hud.customView = customView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    RAC(customView,progress) = [hud rac_valuesForKeyPath:@"progress" observer:hud];
    hud.progress = 0;
    
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.text = @"\n正在保存到本地";
    return hud;
}

@end
