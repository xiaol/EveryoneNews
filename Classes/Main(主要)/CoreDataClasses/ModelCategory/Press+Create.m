//
//  Press+Create.m
//  EveryoneNews
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Press+Create.h"
#import "Album.h"

@implementation Press (Create)
+ (Press *)pressWithTitle:(NSString *)title
                     date:(NSString *)date
               albumObjID:(NSManagedObjectID *)albumOID
   inManagedObjectContext:(NSManagedObjectContext *)context {
    Press *press = [NSEntityDescription insertNewObjectForEntityForName:@"Press" inManagedObjectContext:context];
    [context obtainPermanentIDsForObjects:@[press] error:nil];
    
    Album *album = (Album *)[context existingObjectWithID:albumOID error:nil];
    press.album = album;
    press.title = title;
    press.date = date;
    
    return press;
}

@end
