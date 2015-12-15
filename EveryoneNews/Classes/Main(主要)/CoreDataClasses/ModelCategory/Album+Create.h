//
//  Album+Create.h
//  EveryoneNews
//
//  Created by apple on 15/10/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Album.h"

@interface Album (Create)
+ (Album *)albumWithID:(NSNumber *)albumID
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
        thumbnailImage:(UIImage *)thumbnailImage
inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Album *)albumWithID:(NSNumber *)albumID
                 title:(NSString *)title
              subtitle:(NSString *)subtitle
                 photo:(UIImage *)photo
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
