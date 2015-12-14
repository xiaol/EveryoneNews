//
//  Card+CoreDataProperties.h
//  EveryoneNews
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sourceSiteName;
@property (nullable, nonatomic, retain) NSString *updateTime;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *channelId;
@property (nullable, nonatomic, retain) NSNumber *commentNum;
@property (nullable, nonatomic, retain) NSString *collection;
@property (nullable, nonatomic, retain) NSString *newId;
@property (nullable, nonatomic, retain) NSString *type;
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
