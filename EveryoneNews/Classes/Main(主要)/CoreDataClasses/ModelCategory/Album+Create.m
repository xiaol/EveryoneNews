//
//  Album+Create.m
//  EveryoneNews
//
//  Created by apple on 15/10/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Album+Create.h"
#import "Faulter.h"
#import "AlbumPhoto.h"

@implementation Album (Create)

+ (Album *)albumWithID:(NSNumber *)albumID
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
        thumbnailImage:(UIImage *)thumbnailImage
inManagedObjectContext:(NSManagedObjectContext *)context {
    Album *album = nil;
    
    album = [NSEntityDescription insertNewObjectForEntityForName:@"Album"
        inManagedObjectContext:context];
//    NSLog(@"create albumID : %@", albumID);

    [context obtainPermanentIDsForObjects:@[album] error:nil];
    album.albumID = albumID;
    album.title = title;
    album.subtitle = subtitle;
    album.thumbnail = UIImagePNGRepresentation(thumbnailImage);
    
//    [Faulter faultObjectWithID:album.objectID inContext:context];
    return album;
}

+ (Album *)albumWithID:(NSNumber *)albumID
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
                 photo:(UIImage *)photo
inManagedObjectContext:(NSManagedObjectContext *)context {
    Album *album = nil;
    
    album = [NSEntityDescription insertNewObjectForEntityForName:@"Album"
                                          inManagedObjectContext:context];
//    NSLog(@"create albumID : %@", albumID);
    [context obtainPermanentIDsForObjects:@[album] error:nil];
    album.albumID = albumID;
    album.title = title;
    album.subtitle = subtitle;
    if (!album.photo) {
        AlbumPhoto *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"AlbumPhoto" inManagedObjectContext:context];
        [context obtainPermanentIDsForObjects:@[newPhoto] error:nil];
        album.photo = newPhoto;
    }
    album.photo.data = UIImagePNGRepresentation(photo);
    album.thumbnail = nil;
    return album;
}
@end
