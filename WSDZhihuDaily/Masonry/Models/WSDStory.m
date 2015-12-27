//
//  WSDStory.m
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import "WSDStory.h"

@interface WSDStory ()

@property (nonatomic, assign) BOOL multiPic;

@end

@implementation WSDStory


-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [WSDStory new];
    if (self) {
        self.title = json[@"title"];
        self.storyId = json[@"id"];
        self.gaPrefix = json[@"ga_prefix"];
        self.type = json[@"type"];
        self.multiPic = json[@"multiPic"];
        self.images = json[@"images"];
    }
    return self;
}
@end
