//
//  WSDBannerView.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "WSDBannerView.h"

@interface WSDBannerView ()

@property(nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation WSDBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"WSDBannerView"
                                                      owner:self
                                                    options:nil] firstObject];
        view.frame = self.bounds;
        [self addSubview:view];
        self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bannerImageView.bounds;
        _gradientLayer.colors = @[
                                  (id)[UIColor colorWithWhite:0.2 alpha:0.6].CGColor,
                                  (id)[UIColor clearColor].CGColor,
                                  (id)[UIColor clearColor].CGColor,
                                  (id)[UIColor colorWithWhite:0.2 alpha:0.6].CGColor
                                  ];
        _gradientLayer.locations = @[ @0.0, @0.4, @0.7, @1.0 ];
        //        self.bannerImageView.layer.mask = _gradientLayer;
        [self.bannerImageView.layer addSublayer:_gradientLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.frame = self.bannerImageView.bounds;
    [CATransaction commit];
}

@end
