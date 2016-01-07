//
//  WSDCarouselView.h
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSDCarouselView : UIView

@property (strong, nonatomic) IBOutlet UIView *view;

-(void)setTopStories:(NSArray *)topStories;

@end
