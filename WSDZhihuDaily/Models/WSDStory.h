//
//  WSDStory.h
//  WSDZhihuDaily
//
//  Created by Wang Shudao on 12/25/15.
//  Copyright © 2015 WSD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSDStory : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *storyId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *gaPrefix;
@property (nonatomic, strong) NSArray *images;

-(instancetype)initWithJSON:(NSDictionary *)json;

@end
