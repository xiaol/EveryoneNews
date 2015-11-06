//
//  LPPressListViewController.h
//  EveryoneNews
//
//  Created by apple on 15/10/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoreDataSTVC.h"

@interface LPPressListViewController : CoreDataSTVC
@property (nonatomic, strong) NSManagedObjectID *albumObjID; //NSManagedObjectID is thread-safe

@end
