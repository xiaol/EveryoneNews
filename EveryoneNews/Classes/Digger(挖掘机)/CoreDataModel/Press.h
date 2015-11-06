//
//  Press.h
//  EveryoneNews
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album, Content, PressPhoto, Relate, Zhihu;

@interface Press : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSNumber * isDownload;
@property (nonatomic, retain) NSNumber * isDownloading;
@property (nonatomic, retain) NSString * pressID;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Album *album;
@property (nonatomic, retain) NSSet *contents;
@property (nonatomic, retain) PressPhoto *photo;
@property (nonatomic, retain) NSSet *relates;
@property (nonatomic, retain) NSSet *zhihus;
@end

@interface Press (CoreDataGeneratedAccessors)

- (void)addContentsObject:(Content *)value;
- (void)removeContentsObject:(Content *)value;
- (void)addContents:(NSSet *)values;
- (void)removeContents:(NSSet *)values;

- (void)addRelatesObject:(Relate *)value;
- (void)removeRelatesObject:(Relate *)value;
- (void)addRelates:(NSSet *)values;
- (void)removeRelates:(NSSet *)values;

- (void)addZhihusObject:(Zhihu *)value;
- (void)removeZhihusObject:(Zhihu *)value;
- (void)addZhihus:(NSSet *)values;
- (void)removeZhihus:(NSSet *)values;

@end
