//
//  CardImage+CoreDataProperties.h
//  EveryoneNews
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CardImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imgUrl;
@property (nullable, nonatomic, retain) Card *card;

@end

NS_ASSUME_NONNULL_END
