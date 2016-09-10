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

+ (void)fetchCardsWithCardParam:(CardParam *)param cardsArrayBlock:(cardsArrayBlock)cardsArrayBlock {
    
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
        request.fetchBatchSize = 20;
        request.fetchLimit = param.count.integerValue;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updateTime" ascending:NO]];
        if (param.startTime) {
            // 判断当前频道是不是关注频道
            if ([param.channelID isEqualToString:focusChannelID]) {
                NSInteger utype = [[userDefaults objectForKey:@"utype"] integerValue];
                
                request.predicate = [NSPredicate predicateWithFormat:@"channelId = %@ && utype = %d && isCardDeleted <> 1 && updateTime < %@ ", param.channelID, utype, param.startTime];
            } else {
                request.predicate = [NSPredicate predicateWithFormat:@"channelId = %@ && isCardDeleted <> 1 && updateTime < %@ ", param.channelID, param.startTime];
            }
        }
        [cdh.importContext performBlock:^{
            
            NSError *error = nil;
            NSArray *results  = [cdh.importContext executeFetchRequest:request error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                cardsArrayBlock(results);
            });
            if (error) {
                NSLog(@"importContext error: %@", error);
            }
         
        }];
}

@end
