//
//  WSDDataUtils.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 1/7/16.
//  Copyright © 2016 WSD. All rights reserved.
//

#import "WSDDataUtils.h"

@implementation WSDDataUtils


+(NSString *)todayDateString {
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
	
    return [formatter stringFromDate:today];
}

+(NSString *)dateStringBeforeDays:(NSInteger)days {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *before = [NSDate dateWithTimeIntervalSinceNow:-days*60*60*24];
	
    return [formatter stringFromDate:before];
}
@end
