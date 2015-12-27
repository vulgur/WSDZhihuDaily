//
//  WSDRefreshView.h
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/27/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSDRefreshView : UIView

-(void)updateProgress:(CGFloat)progress;
-(void)startAnimation;
-(void)stopAnimation;

@end
