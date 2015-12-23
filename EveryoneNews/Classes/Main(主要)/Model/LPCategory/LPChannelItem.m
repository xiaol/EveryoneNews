//
//  LPChannel.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPChannelItem.h"

@implementation LPChannelItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.channelID = [aDecoder decodeObjectForKey:@"channelID"];
        self.channelName = [aDecoder decodeObjectForKey:@"channelName"];
        self.channelIsSelected = [aDecoder decodeObjectForKey:@"channelIsSelected"];
        self.lastAccessDate = [aDecoder decodeObjectForKey:@"lastAccessDate"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.channelID forKey:@"channelID"];
    [aCoder encodeObject:self.channelName forKey:@"channelName"];
    [aCoder encodeObject:self.channelIsSelected forKey:@"channelIsSelected"];
    [aCoder encodeObject:self.lastAccessDate forKey:@"lastAccessDate"];
}

@end
