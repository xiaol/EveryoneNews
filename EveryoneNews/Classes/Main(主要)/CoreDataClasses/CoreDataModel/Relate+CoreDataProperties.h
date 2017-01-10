//
//  Relate+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Relate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Relate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *photoURL;
@property (nullable, nonatomic, retain) NSNumber *relateID;
@property (nullable, nonatomic, retain) NSString *sourceSite;
@property (nullable, nonatomic, retain) NSNumber *thumbnailH;
@property (nullable, nonatomic, retain) NSNumber *thumbnailW;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *updateTime;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) RelatePhoto *photo;
@property (nullable, nonatomic, retain) Press *press;

@end

NS_ASSUME_NONNULL_END
