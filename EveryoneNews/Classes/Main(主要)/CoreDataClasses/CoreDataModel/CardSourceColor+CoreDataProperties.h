//
//  CardSourceColor+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/21.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CardSourceColor.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardSourceColor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sourceName;
@property (nullable, nonatomic, retain) NSString *sourceColor;

@end

NS_ASSUME_NONNULL_END
