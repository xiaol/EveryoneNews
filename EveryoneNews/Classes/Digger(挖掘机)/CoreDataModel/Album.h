//
//  Album.h
//  EveryoneNews
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlbumPhoto, Press;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSNumber * albumID;
@property (nonatomic, retain) NSNumber * isUpload;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) AlbumPhoto *photo;
@property (nonatomic, retain) NSSet *presses;
@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addPressesObject:(Press *)value;
- (void)removePressesObject:(Press *)value;
- (void)addPresses:(NSSet *)values;
- (void)removePresses:(NSSet *)values;

@end
