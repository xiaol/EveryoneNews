//
//  ContentPhoto+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/7.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ContentPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentPhoto (CoreDataProperties)

@property (nullable, nonatomic, retain) Content *content;

@end

NS_ASSUME_NONNULL_END
