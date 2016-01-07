//
//  WSDBannerView.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "WSDBannerView.h"

@implementation WSDBannerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"WSDBannerView" owner:self options:nil] firstObject];
        view.frame = self.bounds;
        [self addSubview:view];
        self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        CAGradientLayer *bottomGradientLayer = [CAGradientLayer layer];
        bottomGradientLayer.frame = self.bannerImageView.bounds;
        bottomGradientLayer.colors = @[(id)[UIColor colorWithWhite:0.2 alpha:0.6].CGColor,
                                       (id)[UIColor clearColor].CGColor,
                                       (id)[UIColor clearColor].CGColor,
                                       (id)[UIColor colorWithWhite:0.2 alpha:0.6].CGColor];
        bottomGradientLayer.locations = @[@0.0, @0.4, @0.7, @1.0];
        [self.bannerImageView.layer addSublayer:bottomGradientLayer];
    }
    return self;
}
@end
