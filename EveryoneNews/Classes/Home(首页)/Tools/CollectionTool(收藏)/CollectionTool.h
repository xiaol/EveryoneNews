//
//  CollectionTool.h
//  EveryoneNews
//
//  Created by dongdan on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CollectionQuerySuccessHandler)(NSArray *cards);
typedef void (^CollectionQueryFailureHandler)(NSError *error);
typedef void (^CollectionDeleteFlag)(NSString *deleteFlag);
typedef void (^CodeFlag)(NSString *codeFlag);

@interface CollectionTool : NSObject

+ (void)collectionQuerySuccess:(CollectionQuerySuccessHandler)success failure:(CollectionQueryFailureHandler)failure;

+ (void)deleteCollection:(NSString *)nid deleteFlag:(CollectionDeleteFlag)deleteFlag;

+ (void)addConcernWithNid:(NSString *)nid codeFlag:(CodeFlag)codeFlag;
+ (void)cancelConcernWithNid:(NSString *)nid codeFlag:(CodeFlag)codeFlag;

@end
