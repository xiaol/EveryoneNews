//
//  CardRelate+CoreDataProperties.h
//  EveryoneNews
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CardRelate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardRelate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *compress;
@property (nullable, nonatomic, retain) NSNumber *similarity;
@property (nullable, nonatomic, retain) NSString *sourceSiteName;
@property (nullable, nonatomic, retain) NSString *sourceUrl;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
