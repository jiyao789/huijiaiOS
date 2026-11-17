//
//  CustomAnnotationView.m
//  StandardApplication
//
//  Created by DTiOS on 2021/11/19.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "CustomAnnotationView.h"

#define kCalloutWidth       140.0
#define kCalloutHeight      58.0

@interface CustomAnnotationView ()

@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;

@end

@implementation CustomAnnotationView

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    if (self.selected == selected)
//    {
//        return;
//    }
//    
//    if (selected)
//    {
//        if (self.calloutView == nil)
//        {
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//        }
//        
//        self.calloutView.title = self.annotation.title;
//        
//        [self addSubview:self.calloutView];
//    }
//    else
//    {
//        [self.calloutView removeFromSuperview];
//    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kCalloutWidth, kCalloutHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        self.calloutView.title = self.annotation.title;
        
        [self addSubview:self.calloutView];
    }
    
    return self;
}

@end
