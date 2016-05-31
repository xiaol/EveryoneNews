//
//  Card+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *channelId;
@property (nullable, nonatomic, retain) NSNumber *commentsCount;
@property (nullable, nonatomic, retain) NSString *docId;
@property (nullable, nonatomic, retain) NSNumber *isCardDeleted;
@property (nullable, nonatomic, retain) NSNumber *isCollected;
@property (nullable, nonatomic, retain) NSNumber *isRead;
@property (nullable, nonatomic, retain) NSString *newId;
@property (nullable, nonatomic, retain) NSString *sourceSiteName;
@property (nullable, nonatomic, retain) NSString *sourceSiteURL;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *updateTime;
@property (nullable, nonatomic, retain) NSNumber *nid;
@property (nullable, nonatomic, retain) NSSet<CardImage *> *cardImages;
@property (nullable, nonatomic, retain) NSSet<CardRelate *> *cardRelates;

@end

@interface Card (CoreDataGeneratedAccessors)

- (void)addCardImagesObject:(CardImage *)value;
- (void)removeCardImagesObject:(CardImage *)value;
- (void)addCardImages:(NSSet<CardImage *> *)values;
- (void)removeCardImages:(NSSet<CardImage *> *)values;

- (void)addCardRelatesObject:(CardRelate *)value;
- (void)removeCardRelatesObject:(CardRelate *)value;
- (void)addCardRelates:(NSSet<CardRelate *> *)values;
- (void)removeCardRelates:(NSSet<CardRelate *> *)values;

@end

NS_ASSUME_NONNULL_END
