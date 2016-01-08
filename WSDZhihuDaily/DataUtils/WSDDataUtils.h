//
//  WSDDataUtils.h
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 1/7/16.
//  Copyright © 2016 WSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSDDataUtils : NSObject

+(NSString *)todayDateString;
+(NSString *)dateStringBeforeDays:(NSInteger)days;

@end
