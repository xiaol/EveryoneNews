//
//  CoreDataTVC.h
//  EveryoneNews
//
//  Created by apple on 15/10/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface CoreDataTVC : LPBaseViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) UITableView *tableView;

- (void)performFetch;
@end
