//
//  LPSpecialTopicCard.h
//  EveryoneNews
//
//  Created by dongdan on 2016/10/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSpecialTopicCard : NSObject

@property (nonatomic, strong) NSNumber *channelId;
@property (nonatomic, strong) NSNumber *commentsCount;
@property (nonatomic, copy)  NSString *docId;
@property (nonatomic, strong) NSNumber *nid;
@property (nonatomic, copy)  NSString *sourceSiteName;
@property (nonatomic, copy)  NSString *sourceSiteURL;
@property (nonatomic, copy)  NSString *title;
@property (nonatomic, copy)  NSString *updateTime;
@property (nonatomic, strong) NSArray *cardImages;

@end
