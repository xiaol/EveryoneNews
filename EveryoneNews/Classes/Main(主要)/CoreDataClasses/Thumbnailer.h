//
//  Thumbnailer.h
//  EveryoneNews
//
//  Created by apple on 15/10/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^completionBlock)();

@interface Thumbnailer : NSObject
+ (void)createMissingThumnbnailsForEntityName:(NSString *)entityName
                       thumbnailAttributeName:(NSString *)thumbnailAttributeName
                        photoRelationshipName:(NSString *)photoRelationshipName
                           photoAttributeName:(NSString *)photoAttributeName
                              sortDescriptors:(NSArray *)sortDescriptors
                                thumbnailSize:(CGSize)thumbnailSize
                       inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)createMissingThumnbnailsForEntityName:(NSString *)entityName
                       thumbnailAttributeName:(NSString *)thumbnailAttributeName
                        photoRelationshipName:(NSString *)photoRelationshipName
                           photoAttributeName:(NSString *)photoAttributeName
                              sortDescriptors:(NSArray *)sortDescriptors
                                thumbnailSize:(CGSize)thumbnailSize
                       inManagedObjectContext:(NSManagedObjectContext *)context
                                     faulting:(BOOL)isFaulting;
+ (void)createThumbnailForManagedObject:(NSManagedObject *)managedObject
             withThumbnailAttributeName:(NSString *)thumbnailAttributeName
                  photoRelationshipName:(NSString *)photoRelationshipName
                     photoAttributeName:(NSString *)photoAttributeName
                          thumbnailSize:(CGSize)thumbnailSize
                 inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)changeThumbnailForManagedObject:(NSManagedObject *)managedObject
             withThumbnailAttributeName:(NSString *)thumbnailAttributeName
                                  photo:(UIImage *)photo
                          thumbnailSize:(CGSize)thumbnailSize
                 inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)createThumbnailForManagedObject:(NSManagedObject *)managedObject
             withThumbnailAttributeName:(NSString *)thumbnailAttributeName
                  photoRelationshipName:(NSString *)photoRelationshipName
                     photoAttributeName:(NSString *)photoAttributeName
                          thumbnailSize:(CGSize)thumbnailSize
                 inManagedObjectContext:(NSManagedObjectContext *)context
                             completion:(completionBlock)completionBlock;
@end
