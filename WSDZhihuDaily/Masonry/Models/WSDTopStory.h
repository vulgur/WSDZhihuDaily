//
//  WSDTopStory.h
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "WSDStory.h"

@interface WSDTopStory : WSDStory

@property (nonatomic, strong) NSString *imageURLString;

-(instancetype)initWithJSON:(NSDictionary *)json;

@end
