//
//  WSDCarouselView.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "WSDCarouselView.h"
#import "WSDTopStory.h"
#import "WSDBannerView.h"

@interface WSDCarouselView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WSDCarouselView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.view = [[[NSBundle mainBundle]loadNibNamed:@"WSDCarouselView" owner:self options:nil] firstObject];
        self.view.frame = self.bounds;
        [self addSubview:self.view];
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setTopStories:(NSArray *)topStories {
    if (!topStories) {
        return;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:topStories];
    [arr insertObject:[topStories lastObject] atIndex:0];
    [arr addObject:[topStories firstObject]];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * arr.count, self.bounds.size.height);
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    
    self.pageControl.numberOfPages = topStories.count;
    self.pageControl.currentPage = 0;
    
    UIView *lastBannerView = nil;
    for (int i=0; i < arr.count; i++) {
        WSDTopStory *topStory = arr[i];
        
        WSDBannerView *bannerView = [WSDBannerView new];
        [self.scrollView addSubview:bannerView];
        
        [bannerView.bannerImageView sd_setImageWithURL:[NSURL URLWithString:topStory.imageURLString]];
        bannerView.bannerLabel.text = topStory.title;
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.scrollView.mas_height);
            make.width.mas_equalTo(kScreenWidth);
            make.top.equalTo(self.scrollView.mas_top);
            if (lastBannerView) {
                make.left.equalTo(lastBannerView.mas_right);
            } else {
                make.left.equalTo(self.scrollView.mas_left);
            }
        }];
        
        lastBannerView = bannerView;
//        bannerView.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.view.bounds.size.height);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX ==  6 * kScreenWidth) {
        _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        _pageControl.currentPage = 0;
    } else if (offsetX == 0) {
        _scrollView.contentOffset = CGPointMake(5 * kScreenWidth, 0);
        _pageControl.currentPage = 4;
    } else {
        _pageControl.currentPage = offsetX/kScreenWidth - 1;
    }
}

@end
