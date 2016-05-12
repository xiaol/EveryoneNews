//
//  CoreDataSTVC.h
//  EveryoneNews
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface CoreDataSTVC : LPBaseViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSFetchedResultsController *searchFRC;
@property (nonatomic, strong) UISearchDisplayController *searchDC;

- (NSFetchedResultsController *)frcFromTableView:(UITableView *)tableView;
- (UITableView *)tableViewFromFRC:(NSFetchedResultsController *)frc;
- (void)reloadSearchFRCWithPredicate:(NSPredicate *)predicate
                          entityName:(NSString *)entityName
                     sortDescriptors:(NSArray *)sortDescriptors
                           inContext:(NSManagedObjectContext *)context;

- (void)performFetch;
- (void)configureSearch;
@end
