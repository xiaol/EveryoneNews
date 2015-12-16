//
//  Press+CoreDataProperties.h
//  EveryoneNews
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 apple. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Press.h"

NS_ASSUME_NONNULL_BEGIN

@interface Press (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSNumber *isDownload;
@property (nullable, nonatomic, retain) NSNumber *isDownloading;
@property (nullable, nonatomic, retain) NSString *pressID;
@property (nullable, nonatomic, retain) NSData *thumbnail;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) Album *album;
@property (nullable, nonatomic, retain) NSSet<Content *> *contents;
@property (nullable, nonatomic, retain) PressPhoto *photo;
@property (nullable, nonatomic, retain) NSSet<Relate *> *relates;
@property (nullable, nonatomic, retain) NSSet<Zhihu *> *zhihus;

@end

@interface Press (CoreDataGeneratedAccessors)

- (void)addContentsObject:(Content *)value;
- (void)removeContentsObject:(Content *)value;
- (void)addContents:(NSSet<Content *> *)values;
- (void)removeContents:(NSSet<Content *> *)values;

- (void)addRelatesObject:(Relate *)value;
- (void)removeRelatesObject:(Relate *)value;
- (void)addRelates:(NSSet<Relate *> *)values;
- (void)removeRelates:(NSSet<Relate *> *)values;

- (void)addZhihusObject:(Zhihu *)value;
- (void)removeZhihusObject:(Zhihu *)value;
- (void)addZhihus:(NSSet<Zhihu *> *)values;
- (void)removeZhihus:(NSSet<Zhihu *> *)values;

@end

NS_ASSUME_NONNULL_END
