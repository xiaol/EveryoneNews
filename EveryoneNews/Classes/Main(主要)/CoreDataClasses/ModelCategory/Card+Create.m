//
//  Card+Create.m
//  EveryoneNews
//
//  Created by apple on 15/12/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "Card+Create.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "CardImage+Create.h"
#import "CardRelate+Create.h"
#import "Card+Fetch.h"
#import "Comment.h"
#import "LPFontSizeManager.h"
#import "LPFontSize.h"
#import "CardConcern+Create.h"
#import "CardSourceColor+Create.h"


@implementation Card (Create)


+ (NSMutableAttributedString *)titleHtmlString:(NSString *)title {
    // font-family: STHeiti, Helvetica Neue; 
    CGFloat fontSize = [LPFontSizeManager sharedManager].lpFontSize.currentHomeViewFontSize ;
    title = [NSString stringWithFormat:@"<style> body{ font-family: STHeiti, Helvetica Neue; font-weight:5; line-height:1.0;text-indent:0em;font-size:%fpx; text-align:justify; }</style> %@ ",
            [UIFont systemFontOfSize:fontSize].pointSize, [[title stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                                     documentAttributes:nil error:nil];
    return mutableAttributeString;
}

+ (NSMutableAttributedString *)titleHtmlString:(NSString *)title isRead:(NSNumber *)isRead {
    
    NSString *color = (isRead? @"#808080" : @"#1a1a1a");
    CGFloat fontSize = [LPFontSizeManager sharedManager].lpFontSize.currentHomeViewFontSize ;
    title = [NSString stringWithFormat:@"<style> body{font-family: STHeiti, Helvetica Neue;font-weight:5; line-height:1.0;text-indent:0em;font-size:%fpx; text-align:justify;color:%@  }</style> %@ ",
             [UIFont systemFontOfSize:fontSize].pointSize, color, [[title stringByReplacingOccurrencesOfString:@"<p>" withString:@""] stringByReplacingOccurrencesOfString:@"</p>" withString:@""]];
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithData:[title dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                                documentAttributes:nil error:nil];
    return mutableAttributeString;
}

+ (void)createCardsWithDictArray:(NSArray *)dicts
                    channelID:(NSString *)channelID cardsArrayBlock:(cardsArrayBlock)cardsArrayBlock {
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        NSMutableArray *cards = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            Card *card = [self createCardWithDict:dict channelID:channelID inManagedObjectContext:cdh.importContext];
            [cards addObject:card];
        }
        [cdh saveBackgroundContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            cardsArrayBlock([cards copy]);
        });
    }];
}

+ (void)saveCardiSRead:(Card *)card {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:cdh.importContext];
    [fetch setEntity:entityDescription];
    if ([[card.channelId stringValue] isEqualToString:focusChannelID]) {
        NSInteger utype = [[userDefaults objectForKey:@"utype"] integerValue];
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@ and channelId = %@ and utype = %d",card.nid, card.channelId, utype]];
    } else {
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@ and channelId = %@",card.nid, card.channelId]];
    }
    NSError * error = nil;
    NSArray *fetchedObjects;
    fetchedObjects = [cdh.importContext executeFetchRequest:fetch error:&error];
    if (fetchedObjects.count > 0) {
        [card setValue:@(1) forKey:@"isRead"];
        [cdh saveBackgroundContext];
    }
}

+ (void)cancelConcernCardsWithDictArray:(NSArray *)dicts
                       channelID:(NSString *)channelID
                             sourceName:(NSString *)sourceName
                        cardsArrayBlock:(cardsArrayBlock)cardsArrayBlock {
    
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:cdh.importContext];
    [fetch setEntity:entityDescription];
    NSInteger utype = [[userDefaults objectForKey:@"utype"] integerValue];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"sourceSiteName = %@ and channelId = %@ and utype = %d",sourceName, focusChannelID, utype]];
    NSError * error = nil;
    NSArray *fetchedObjects;
    fetchedObjects = [cdh.importContext executeFetchRequest:fetch error:&error];
    
    if ([fetchedObjects count] > 0 ) {
        [cdh.importContext performBlock:^{
            // 先删除 后插入
            for (NSManagedObject *manageObject in fetchedObjects) {
                [cdh.importContext deleteObject:manageObject];
            }
            [cdh saveBackgroundContext];
            NSMutableArray *cards = [NSMutableArray array];
            for (NSDictionary *dict in dicts) {
                Card *card = [self createCardWithDict:dict channelID:channelID inManagedObjectContext:cdh.importContext];
                [cards addObject:card];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cardsArrayBlock([cards copy]);
            });
        }];
    } else {
        // 直接存储
        [cdh.importContext performBlock:^{
            NSMutableArray *cards = [NSMutableArray array];
            for (NSDictionary *dict in dicts) {
                Card *card = [self createCardWithDict:dict channelID:channelID inManagedObjectContext:cdh.importContext];
                [cards addObject:card];
            }
            [cdh saveBackgroundContext];
            dispatch_async(dispatch_get_main_queue(), ^{
                cardsArrayBlock([cards copy]);
            });
        }];
    }
}

+ (Card *)createCardWithDict:(NSDictionary *)dict channelID:(NSString *)channelID
      inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Card *card = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:context];
    [fetch setEntity:entityDescription];
    // 关注频道单独处理
     NSInteger utype = [[userDefaults objectForKey:@"utype"] integerValue];
    if ([channelID isEqualToString:focusChannelID]) {
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@ and channelId = %@ and utype = %d",dict[@"nid"], channelID, utype]];
    } else {
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@ and channelId = %d",dict[@"nid"], [channelID integerValue]]];
    }
    
    NSError * error = nil;
    NSArray *fetchedObjects;
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    
    if (error == nil) {
        if ([fetchedObjects count] == 0 ) {
            card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:context];
            [context obtainPermanentIDsForObjects:@[card] error:nil];
            card.nid = dict[@"nid"];
            card.title = dict[@"title"];
            card.sourceSiteURL = dict[@"purl"];
            card.sourceSiteName = dict[@"pname"];
            card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
            // 奇点频道和关注频道编号需要做单独处理
            if ([channelID isEqualToString:@"1"]) {
                card.channelId = @(1);
            } else if ([channelID  isEqualToString:focusChannelID]) {
                card.channelId = @(99999);
                card.keyword = dict[@"pname"];
                card.keywordColor = [CardSourceColor sourceColorWithKeyword:dict[@"pname"] context:context];
                card.utype = [NSNumber numberWithInteger:utype];
            } else {
                card.channelId = dict[@"channel"];
                
            }
            card.rtype = dict[@"rtype"];
            // 专题测试
//            if ([dict[@"rtype"] integerValue] == 1) {
//                card.rtype = @(4);
//            }
            card.type = dict[@"style"];
            card.docId = dict[@"docid"];
            card.commentsCount = dict[@"comment"];
            [CardImage createCardImagesWithURLArray:dict[@"imgs"]
                                               card:card
                             inManagedObjectContext:context];
    
        } else {
            card = [fetchedObjects objectAtIndex:0];
        }
    }
    return card;
}


#pragma mark - 取消关注
+ (void)cancelConcernCard:(NSString *)sourceSiteName {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:cdh.importContext];
    [fetch setEntity:entityDescription];
    NSInteger utype = [[userDefaults objectForKey:@"utype"] integerValue];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"sourceSiteName = %@ and channelId = %@ and utype = %d",sourceSiteName, focusChannelID, utype]];

    NSError * error = nil;
    NSArray *fetchedObjects;
    fetchedObjects = [cdh.importContext executeFetchRequest:fetch error:&error];
    if ([fetchedObjects count] > 0 ) {
          [cdh.importContext performBlock:^{
              for (NSManagedObject *manageObject in fetchedObjects) {
                  [cdh.importContext deleteObject:manageObject];
              }
              [cdh saveBackgroundContext];
          }];
    }
    
}


#pragma mark - 收藏
+ (void)updateCard:(Card *)card {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        [cdh saveBackgroundContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新成功");
        });
    }];
}

+ (void)createCardWithDict:(NSDictionary *)cardDict commentDict:(NSDictionary *)commentDict {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        
        // 创建card对象
        Card *card = nil;
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:cdh.importContext ];
        [fetch setEntity:entityDescription];
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@",cardDict[@"nid"]]];
        
        NSError * error = nil;
        NSArray *fetchedObjects;
        fetchedObjects = [cdh.importContext  executeFetchRequest:fetch error:&error];
        // 本地没有就创建
        if ([fetchedObjects count] == 0 ) {
            card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:cdh.importContext];
            [cdh.importContext obtainPermanentIDsForObjects:@[card] error:nil];
            card.nid = cardDict[@"nid"];
            card.title = cardDict[@"title"];
            card.sourceSiteURL = cardDict[@"purl"];
            card.sourceSiteName = cardDict[@"pname"];
            card.updateTime = cardDict[@"ptime"];
            // 热点频道存入数据库需要更新当前频道编号
            card.channelId = cardDict[@"channel"];
            card.type = cardDict[@"style"];
            card.docId = cardDict[@"docid"];
            card.commentsCount = cardDict[@"comment"];
            [CardImage createCardImagesWithURLArray:cardDict[@"imgs"]
                                               card:card
                             inManagedObjectContext:cdh.importContext];
            
        } else {
            card = [fetchedObjects objectAtIndex:0];
        }
        
        // 创建comment对象
        Comment  *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:cdh.importContext];
        [cdh.importContext obtainPermanentIDsForObjects:@[comment] error:nil];
        comment.commentID = commentDict[@"commentID"];
        comment.upFlag = commentDict[@"upFlag"];
        comment.title = commentDict[@"title"];
        comment.nid = commentDict[@"nid"];
        comment.commend = commentDict[@"commend"];
        comment.commentTime = [NSString stringWithFormat:@"%lld", (long long)([commentDict[@"commentTime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
        comment.comment = commentDict[@"comment"];
        comment.card = card;
        
        [cdh saveBackgroundContext];
        
    }];
}

+ (void)createCardWithDict:(NSDictionary *)cardDict isCollected:(BOOL)isCollected {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        
        // 创建card对象
        Card *card = nil;
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:cdh.importContext ];
        [fetch setEntity:entityDescription];
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@",cardDict[@"nid"]]];
        
        NSError * error = nil;
        NSArray *fetchedObjects;
        fetchedObjects = [cdh.importContext  executeFetchRequest:fetch error:&error];
        // 本地没有就创建
        if ([fetchedObjects count] == 0 ) {
            card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:cdh.importContext];
            [cdh.importContext obtainPermanentIDsForObjects:@[card] error:nil];
            card.nid = cardDict[@"nid"];
            card.title = cardDict[@"title"];
            card.sourceSiteURL = cardDict[@"purl"];
            card.sourceSiteName = cardDict[@"pname"];
            card.updateTime = [NSString stringWithFormat:@"%lld", (long long)([cardDict[@"ptime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
            // 热点频道存入数据库需要更新当前频道编号
            card.channelId = cardDict[@"channel"];
            card.type = cardDict[@"style"];
            card.docId = cardDict[@"docid"];
            card.commentsCount = cardDict[@"comment"];
            [CardImage createCardImagesWithURLArray:cardDict[@"imgs"]
                                               card:card
                             inManagedObjectContext:cdh.importContext];
            
        } else {
            card = [fetchedObjects objectAtIndex:0];
        }
        if (isCollected) {
            card.isCollected = @(1);
        } else {
            card.isCollected = @(0);
        }
        [cdh saveBackgroundContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新成功");
        });
    }];
}

+ (void)cardIsCollected:(NSString *)nid cardIsCollectedBlock:(cardIsCollectedBlock)cardIsCollectedBlock {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        
        // 创建card对象
        Card *card = nil;
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Card" inManagedObjectContext:cdh.importContext ];
        [fetch setEntity:entityDescription];
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"nid = %@ ",nid]];
        
        NSError * error = nil;
        NSArray *fetchedObjects;
        fetchedObjects = [cdh.importContext  executeFetchRequest:fetch error:&error];
        // 本地没有就创建
        if ([fetchedObjects count] == 0 ) {
            cardIsCollectedBlock(false, false);
        } else {
            card = [fetchedObjects objectAtIndex:0];
            if ([card.isCollected isEqual: @(1)]) {
                cardIsCollectedBlock(true, true);
            } else {
                cardIsCollectedBlock(false, true);
            }
        }
    }];
}



@end
