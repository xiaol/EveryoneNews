//
//  Zhihu+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Zhihu.h"

NS_ASSUME_NONNULL_BEGIN

@interface Zhihu (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *user;
@property (nullable, nonatomic, retain) NSNumber *zhihuID;
@property (nullable, nonatomic, retain) Press *press;

@end

NS_ASSUME_NONNULL_END
