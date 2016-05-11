//
//  Thumbnailer.m
//  EveryoneNews
//
//  Created by apple on 15/10/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Thumbnailer.h"
#import "Faulter.h"

@implementation Thumbnailer
+ (void)createMissingThumnbnailsForEntityName:(NSString *)entityName
                       thumbnailAttributeName:(NSString *)thumbnailAttributeName
                        photoRelationshipName:(NSString *)photoRelationshipName
                           photoAttributeName:(NSString *)photoAttributeName
                              sortDescriptors:(NSArray *)sortDescriptors
                                thumbnailSize:(CGSize)thumbnailSize
                       inManagedObjectContext:(NSManagedObjectContext *)context {
    [self createMissingThumnbnailsForEntityName:entityName thumbnailAttributeName:thumbnailAttributeName photoRelationshipName:photoRelationshipName photoAttributeName:photoAttributeName sortDescriptors:sortDescriptors thumbnailSize:thumbnailSize inManagedObjectContext:context faulting:YES];
}

+ (void)createMissingThumnbnailsForEntityName:(NSString *)entityName
                       thumbnailAttributeName:(NSString *)thumbnailAttributeName
                        photoRelationshipName:(NSString *)photoRelationshipName
                           photoAttributeName:(NSString *)photoAttributeName
                              sortDescriptors:(NSArray *)sortDescriptors
                                thumbnailSize:(CGSize)thumbnailSize
                       inManagedObjectContext:(NSManagedObjectContext *)context
                                     faulting:(BOOL)isFaulting {
    [context performBlock:^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
        request.predicate = [NSPredicate predicateWithFormat:@"%K==nil && %K.%K!=nil", thumbnailAttributeName, photoRelationshipName, photoAttributeName];
        request.sortDescriptors = sortDescriptors;
        request.fetchBatchSize = 15;
        NSError *error;
        NSArray *missingThumbnailObjects = [context executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"Create Missing Thumnbnails Error: %@", error);
        }
        if (!missingThumbnailObjects.count) {
            //            NSLog(@"no missing thumbnails!");
            return;
        }
        for (NSManagedObject *managedObject in missingThumbnailObjects) {
            NSManagedObject *photoObject = [managedObject valueForKey:photoRelationshipName];
            if (![managedObject valueForKey:thumbnailAttributeName] && [photoObject valueForKey:photoAttributeName]) {
                // 创建缩略图
                // 1. 取出图像
                UIImage *photo = [UIImage imageWithData:[photoObject valueForKey:photoAttributeName]];
                // 2. 开启上下文绘制缩略图
                CGSize photoSize = photo.size;
                CGSize size;
                if (thumbnailSize.width >= thumbnailSize.height) {
                    size.width = thumbnailSize.width;
                    size.height = photoSize.height * thumbnailSize.width / photoSize.width;
                } else {
                    size.height = thumbnailSize.height;
                    size.width = photoSize.width * thumbnailSize.height / photoSize.height;
                }
                UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
                [photo drawInRect:CGRectMake(0, 0, size.width, size.height)];
                UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [managedObject setValue:UIImagePNGRepresentation(thumbnail) forKey:thumbnailAttributeName];
                
                if (isFaulting) {
                    [Faulter faultObjectWithID:photoObject.objectID inContext:context];
                    [Faulter faultObjectWithID:managedObject.objectID inContext:context];
                }
                photo = nil;
                thumbnail = nil;
            }
        }
    }];
}

+ (void)createThumbnailForManagedObject:(NSManagedObject *)managedObject
             withThumbnailAttributeName:(NSString *)thumbnailAttributeName
                  photoRelationshipName:(NSString *)photoRelationshipName
                     photoAttributeName:(NSString *)photoAttributeName
                          thumbnailSize:(CGSize)thumbnailSize
                 inManagedObjectContext:(NSManagedObjectContext *)context
                             completion:(completionBlock)completionBlock {
    [context performBlock:^{
        NSManagedObject *photoObject = [managedObject valueForKey:photoRelationshipName];
        
        if ([managedObject valueForKey:thumbnailAttributeName] || ![photoObject valueForKey:photoAttributeName]) return;
        
        UIImage *photo = [UIImage imageWithData:[photoObject valueForKey:photoAttributeName]];
        // 2. 开启上下文绘制缩略图
        CGSize photoSize = photo.size;
        CGSize size;
        if (thumbnailSize.width >= thumbnailSize.height) {
            size.width = thumbnailSize.width;
            size.height = photoSize.height * thumbnailSize.width / photoSize.width;
        } else {
            size.height = thumbnailSize.height;
            size.width = photoSize.width * thumbnailSize.height / photoSize.height;
        }
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        [photo drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [managedObject setValue:UIImagePNGRepresentation(thumbnail) forKey:thumbnailAttributeName];
        
        [Faulter faultObjectWithID:photoObject.objectID inContext:context];
        [Faulter faultObjectWithID:managedObject.objectID inContext:context];
        
        photo = nil;
        thumbnail = nil;
        
        if (completionBlock) {
            completionBlock();
        }
    }];

}


+ (void)createThumbnailForManagedObject:(NSManagedObject *)managedObject
             withThumbnailAttributeName:(NSString *)thumbnailAttributeName
                  photoRelationshipName:(NSString *)photoRelationshipName
                     photoAttributeName:(NSString *)photoAttributeName
                          thumbnailSize:(CGSize)thumbnailSize
                 inManagedObjectContext:(NSManagedObjectContext *)context {
    [self createThumbnailForManagedObject:managedObject withThumbnailAttributeName:thumbnailAttributeName photoRelationshipName:photoRelationshipName photoAttributeName:photoAttributeName thumbnailSize:thumbnailSize inManagedObjectContext:context completion:nil];
}

+ (void)changeThumbnailForManagedObject:(NSManagedObject *)managedObject
             withThumbnailAttributeName:(NSString *)thumbnailAttributeName
                                  photo:(UIImage *)photo
                          thumbnailSize:(CGSize)thumbnailSize
                 inManagedObjectContext:(NSManagedObjectContext *)context {
    CGSize photoSize = photo.size;
    CGSize size;
    if (thumbnailSize.width >= thumbnailSize.height) {
        size.width = thumbnailSize.width;
        size.height = photoSize.height * thumbnailSize.width / photoSize.width;
    } else {
        size.height = thumbnailSize.height;
        size.width = photoSize.width * thumbnailSize.height / photoSize.height;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [photo drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [managedObject setValue:UIImagePNGRepresentation(thumbnail) forKey:thumbnailAttributeName];
    [Faulter faultObjectWithID:managedObject.objectID inContext:context];
    thumbnail = nil;
}
@end
