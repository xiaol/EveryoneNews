//
//  CardImage+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
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
