//
//  AlbumPhoto+CoreDataProperties.h
//  EveryoneNews
//
//  Created by apple on 15/12/15.
//  Copyright © 2015年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AlbumPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlbumPhoto (CoreDataProperties)

@property (nullable, nonatomic, retain) Album *album;

@end

NS_ASSUME_NONNULL_END
