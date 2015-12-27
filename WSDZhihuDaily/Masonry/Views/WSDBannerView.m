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
    }
    return self;
}
@end
