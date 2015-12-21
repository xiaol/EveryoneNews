//
//  Card+Fetch.m
//  EveryoneNews
//
//  Created by apple on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataHelper.h"
#import "Card+Fetch.h"
#import "CardParam.h"

@implementation Card (Fetch)

+ (NSArray *)fetchCardsWithCardParam:(CardParam *)param {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    request.fetchBatchSize = 20;
    request.fetchLimit = param.count.integerValue;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updateTime" ascending:NO]];
    if (param.startTime) {
        request.predicate = [NSPredicate predicateWithFormat:@"channelId = %@ && updateTime < %@", param.channelID, param.startTime];
    }
    NSArray *results = [cdh.context executeFetchRequest:request error:nil];
    return results;
}

@end
