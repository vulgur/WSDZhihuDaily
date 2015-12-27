//
//  WSDTopStory.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "WSDTopStory.h"

@implementation WSDTopStory

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [WSDTopStory new];
    if (self) {
        self.title = json[@"title"];
        self.storyId = json[@"id"];
        self.gaPrefix = json[@"ga_prefix"];
        self.type = json[@"type"];
        self.imageURLString = json[@"image"];
    }
    return self;
}
@end
