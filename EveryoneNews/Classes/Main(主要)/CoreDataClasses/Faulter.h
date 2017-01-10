//
//  Faulter.h
//  EveryoneNews
//
//  Created by apple on 15/10/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Faulter : NSObject
+ (void)faultObjectWithID:(NSManagedObjectID *)objectID inContext:(NSManagedObjectContext *)context;
@end
