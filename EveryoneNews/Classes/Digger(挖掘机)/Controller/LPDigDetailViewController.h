//
//  LPDigDetailViewController.h
//  EveryoneNews
//
//  Created by apple on 15/10/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoreDataTVC.h"

@interface LPDigDetailViewController : LPBaseViewController 
@property (nonatomic, strong) NSManagedObjectID *pressObjID; //NSManagedObjectID is thread-safe
@end
