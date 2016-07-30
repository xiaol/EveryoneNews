//
//  Card+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"
@class CardConcern;
NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *channelId;
@property (nullable, nonatomic, retain) NSNumber *commentsCount;
@property (nullable, nonatomic, retain) NSString *docId;
@property (nullable, nonatomic, retain) NSNumber *isCardDeleted;
@property (nullable, nonatomic, retain) NSNumber *isCollected;
@property (nullable, nonatomic, retain) NSNumber *isRead;
@property (nullable, nonatomic, retain) NSString *newId;
@property (nullable, nonatomic, retain) NSNumber *nid;
@property (nullable, nonatomic, retain) NSString *sourceSiteName;
@property (nullable, nonatomic, retain) NSString *sourceSiteURL;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSString *updateTime;
@property (nullable, nonatomic, retain) CardConcern *cardConcern;
@property (nullable, nonatomic, retain) NSOrderedSet<CardImage *> *cardImages;
@property (nullable, nonatomic, retain) NSSet<CardRelate *> *cardRelates;
@property (nullable, nonatomic, retain) NSSet<Comment *> *comments;

@end

@interface Card (CoreDataGeneratedAccessors)

- (void)insertObject:(CardImage *)value inCardImagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCardImagesAtIndex:(NSUInteger)idx;
- (void)insertCardImages:(NSArray<CardImage *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCardImagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCardImagesAtIndex:(NSUInteger)idx withObject:(CardImage *)value;
- (void)replaceCardImagesAtIndexes:(NSIndexSet *)indexes withCardImages:(NSArray<CardImage *> *)values;
- (void)addCardImagesObject:(CardImage *)value;
- (void)removeCardImagesObject:(CardImage *)value;
- (void)addCardImages:(NSOrderedSet<CardImage *> *)values;
- (void)removeCardImages:(NSOrderedSet<CardImage *> *)values;

- (void)addCardRelatesObject:(CardRelate *)value;
- (void)removeCardRelatesObject:(CardRelate *)value;
- (void)addCardRelates:(NSSet<CardRelate *> *)values;
- (void)removeCardRelates:(NSSet<CardRelate *> *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet<Comment *> *)values;
- (void)removeComments:(NSSet<Comment *> *)values;

@end

NS_ASSUME_NONNULL_END
