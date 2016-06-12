//
//  Comment+Create.m
//  EveryoneNews
//
//  Created by dongdan on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Comment+Create.h"
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Card.h"

@implementation Comment (Create)

+ (void)createCommentWithDict:(NSDictionary *)dict card:(Card *)card {
 
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
 
    Comment  *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:cdh.importContext];
    [cdh.importContext obtainPermanentIDsForObjects:@[comment] error:nil];
    comment.commentID = dict[@"commentID"];
    comment.upFlag = dict[@"upFlag"];
    comment.title = dict[@"title"];
    comment.nid = dict[@"nid"];
    comment.commend = dict[@"commend"];
    comment.commentTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"commentTime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
    comment.comment = dict[@"comment"];
    comment.card = card;
    [cdh.importContext performBlock:^{
        [cdh saveBackgroundContext];
 
    }];
}


+ (NSArray *)getPersonalComment {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"commentTime" ascending:NO]];
    NSError *error = nil;
    NSArray *results  = [cdh.importContext executeFetchRequest:request error:&error];
    return results;
}

+ (void)deleteComment:(Comment *)comment {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    [cdh.importContext performBlock:^{
        [cdh.importContext deleteObject:comment];
        [cdh saveBackgroundContext];
    }];
}

@end



