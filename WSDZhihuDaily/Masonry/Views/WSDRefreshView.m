//
//  WSDRefreshView.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/27/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "WSDRefreshView.h"

@interface WSDRefreshView ()

@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property(nonatomic, strong) CAShapeLayer *whiteCircleShapeLayer;
@property(nonatomic, strong) CAShapeLayer *grayCircleShapeLayer;

@end

@implementation WSDRefreshView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        LxDBAnyVar(self.frame);
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:self.bounds];
    
    _grayCircleShapeLayer = [CAShapeLayer layer];
    _grayCircleShapeLayer.lineWidth = 2.f;
    _grayCircleShapeLayer.strokeColor = [UIColor grayColor].CGColor;
    _grayCircleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _grayCircleShapeLayer.opacity = 0;
    _grayCircleShapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    
    _whiteCircleShapeLayer = [CAShapeLayer layer];
    _whiteCircleShapeLayer.lineWidth = 2.f;
    _whiteCircleShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    _whiteCircleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _whiteCircleShapeLayer.opacity = 0;
    _whiteCircleShapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.width/2)
                                                                 radius:self.width/2
                                                             startAngle:M_PI_2 endAngle:M_PI * 5 / 2
                                                              clockwise:YES].CGPath;
    _whiteCircleShapeLayer.strokeEnd = 0;
    
    [self addSubview:_indicatorView];
    [self.layer addSublayer:_grayCircleShapeLayer];
    [self.layer addSublayer:_whiteCircleShapeLayer];
}

-(void)updateProgress:(CGFloat)progress {
    if (progress <= 0) {
        _whiteCircleShapeLayer.opacity = 0;
        _grayCircleShapeLayer.opacity = 0;
    } else {
        _whiteCircleShapeLayer.opacity = 1;
        _grayCircleShapeLayer.opacity = 1;
    }
    
    if (progress > 1) {
        progress = 1;
    }
    _whiteCircleShapeLayer.strokeEnd = progress;
}

-(void)startAnimation {
    [self.indicatorView startAnimating];
}

-(void)stopAnimation {
    [self.indicatorView stopAnimating];
}

@end
