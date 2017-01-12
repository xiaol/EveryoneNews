//
//  CardConcern+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CardConcern.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardConcern (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *keyword;
@property (nullable, nonatomic, retain) NSString *keywordColor;
@property (nullable, nonatomic, retain) NSNumber *utype;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
