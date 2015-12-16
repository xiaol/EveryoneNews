//
//  ContentPhoto+CoreDataProperties.h
//  EveryoneNews
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
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
