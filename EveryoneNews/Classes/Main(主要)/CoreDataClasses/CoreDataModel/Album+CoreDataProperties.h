//
//  Album+CoreDataProperties.h
//  EveryoneNews
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Album.h"

NS_ASSUME_NONNULL_BEGIN

@interface Album (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *albumID;
@property (nullable, nonatomic, retain) NSNumber *isUpload;
@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nullable, nonatomic, retain) NSData *thumbnail;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) AlbumPhoto *photo;
@property (nullable, nonatomic, retain) NSSet<Press *> *presses;

@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addPressesObject:(Press *)value;
- (void)removePressesObject:(Press *)value;
- (void)addPresses:(NSSet<Press *> *)values;
- (void)removePresses:(NSSet<Press *> *)values;

@end

NS_ASSUME_NONNULL_END
