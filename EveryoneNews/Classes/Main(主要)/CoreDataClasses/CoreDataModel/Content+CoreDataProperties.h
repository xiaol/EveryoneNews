//
//  Content+CoreDataProperties.h
//  EveryoneNews
//
//  Created by dongdan on 16/6/7.
//  Copyright © 2016年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Content.h"

NS_ASSUME_NONNULL_BEGIN

@interface Content (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSNumber *isPhotoType;
@property (nullable, nonatomic, retain) NSNumber *paraID;
@property (nullable, nonatomic, retain) NSString *photoURL;
@property (nullable, nonatomic, retain) NSData *thumbnail;
@property (nullable, nonatomic, retain) NSString *thumbnailDesc;
@property (nullable, nonatomic, retain) ContentPhoto *photo;
@property (nullable, nonatomic, retain) Press *press;

@end

NS_ASSUME_NONNULL_END
