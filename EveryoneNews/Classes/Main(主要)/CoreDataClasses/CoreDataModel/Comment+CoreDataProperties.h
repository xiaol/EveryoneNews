//
//  Comment+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *commend;
@property (nullable, nonatomic, retain) NSString *comment;
@property (nullable, nonatomic, retain) NSString *commentID;
@property (nullable, nonatomic, retain) NSString *commentTime;
@property (nullable, nonatomic, retain) NSString *nid;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *upFlag;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
