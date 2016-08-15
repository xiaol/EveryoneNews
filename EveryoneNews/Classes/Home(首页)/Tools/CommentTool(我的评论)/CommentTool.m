//
//  CommentTool.m
//  EveryoneNews
//
//  Created by dongdan on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommentTool.h"
#import "LPHttpTool.h"
#import "LPMyComment.h"

@implementation CommentTool

+ (void)commentsQuerySuccess:(CommentsQuerySuccessHandler)success failure:(CommentsQueryFailureHandler)failure {
    
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSString *uid = [[userDefaults objectForKey:@"uid"] stringValue];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = uid;
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/au/coms", ServerUrlVersion2];
    [LPHttpTool getJsonAuthorizationWithURL:url authorization:authorization params:paramDict success:^(id json) {
        
        // 有数据
        if ([json[@"code"] integerValue] == 2000) {
            NSArray *jsonData = json[@"data"];
            NSMutableArray *commentArray = [NSMutableArray array];
            for (NSDictionary *dict in jsonData) {
                LPMyComment *comment = [[LPMyComment alloc] init];
                comment.commentID = dict[@"id"];
                comment.upFlag = dict[@"upflag"];
                comment.docID = dict[@"docid"] ;
                comment.title = dict[@"ntitle"] ;
                comment.nid = [dict[@"nid"] stringValue] ;
                comment.commend = dict[@"commend"];
                comment.commentTime = [NSString stringWithFormat:@"%lld", (long long)([dict[@"ctime"] timestampWithDateFormat:@"YYYY-MM-dd HH:mm:ss"] * 1000)];
                comment.comment = dict[@"content"];
                [commentArray addObject:comment];
            }
            success(commentArray);
        }
        // 没有数据
        else if ([json[@"code"] integerValue] == 2002) {
            NSArray *commentArray = [[NSArray alloc] init];
            success(commentArray);
        }
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}

+ (void)deleteComment:(LPMyComment *)comment deleteFlag:(CommentsDeleteFlag)deleteFlag {
    NSString *authorization = [userDefaults objectForKey:@"uauthorization"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"did"] = [[comment.docID  stringByBase64Encoding] stringByTrimmingString:@"="];
    paramDict[@"cid"] = comment.commentID;
    NSString *url = [NSString stringWithFormat:@"%@/v2/ns/au/coms", ServerUrlVersion2];

    [LPHttpTool deleteAuthorizationJSONWithURL:url authorization:authorization params:paramDict success:^(id json) {
        if ([json[@"code"] integerValue] == 2000) {
            deleteFlag(LPSuccess);
        }
        // 没有数据
        else if ([json[@"code"] integerValue] == 2002) {
            deleteFlag(LPFailure);
            
        }
    } failure:^(NSError *error) {
        deleteFlag(LPFailure);
        NSLog(@"%@", error);
    }];
}

@end
