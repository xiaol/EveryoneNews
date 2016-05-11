//
//  LPEditAlbumViewController.h
//  EveryoneNews
//
//  Created by apple on 15/10/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPBaseViewController.h"
#import <CoreData/CoreData.h>

extern NSString * const AlbumDidEditSuccessNotification;


@interface LPEditAlbumViewController : LPBaseViewController
@property (nonatomic, strong) NSManagedObjectID *albumObjID;
@end
