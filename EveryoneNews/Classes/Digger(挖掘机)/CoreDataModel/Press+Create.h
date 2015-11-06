//
//  Press+Create.h
//  EveryoneNews
//
//  Created by apple on 15/10/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Press.h"

@interface Press (Create)
+ (Press *)pressWithTitle:(NSString *)title
                     date:(NSString *)date
               albumObjID:(NSManagedObjectID *)albumOID
   inManagedObjectContext:(NSManagedObjectContext *)context;
@end
