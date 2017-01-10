//
//  CoreDataSTVC.m
//  EveryoneNews
//
//  Created by apple on 15/10/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoreDataSTVC.h"

@interface CoreDataSTVC ()

@end

@implementation CoreDataSTVC

#define debug 0

#pragma mark - configure search display controller
- (void)configureSearch {
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.0f)];
    bar.layer.borderWidth = 1;
    bar.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    bar.barTintColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    bar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.tableView.tableHeaderView = bar;
    [self.tableView setContentOffset:CGPointMake(0, 44)];
    
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:bar contentsController:self];
    self.searchDC.delegate = self;
    self.searchDC.searchResultsDataSource = self;
    self.searchDC.searchResultsDelegate = self;
    self.searchDC.searchContentsController.navigationController.navigationBarHidden = YES;
}

#pragma mark - frc perform fetch
- (void)performFetch {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (self.frc) {
        [self.frc.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![self.frc performFetch:&error]) {
                NSLog(@"Failed to perform fetch: %@", error);
            }
            [self.tableView reloadData];
        }];
    } else {
        NSLog(@"Failed to fetch, the fetched results controller is nil.");
    }
}

#pragma mark - general
- (NSFetchedResultsController *)frcFromTableView:(UITableView *)tableView {
    return (tableView == self.tableView) ? self.frc : self.searchFRC;
}

- (UITableView *)tableViewFromFRC:(NSFetchedResultsController *)frc {
    return (frc == self.frc) ? self.tableView : self.searchDC.searchResultsTableView;
}

#pragma mark - table view data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[[self frcFromTableView:tableView].sections objectAtIndex:section] numberOfObjects];
}

#pragma mark - frc delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self tableViewFromFRC:controller] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UITableView *tableView = [self tableViewFromFRC:controller];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [[self tableViewFromFRC:controller] endUpdates];
}

#pragma mark - search display delegate
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.searchFRC.delegate = nil;
    self.searchFRC = nil;
}

#pragma mark - reload searchFRC 
- (void)reloadSearchFRCWithPredicate:(NSPredicate *)predicate
                          entityName:(NSString *)entityName
                     sortDescriptors:(NSArray *)sortDescriptors
                           inContext:(NSManagedObjectContext *)context {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // 创建searchFRC, 设置代理并查询
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.fetchBatchSize = 15;
    request.predicate = predicate;
    request.sortDescriptors = sortDescriptors;
    self.searchFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.searchFRC.delegate = self;
    
    [self.searchFRC.managedObjectContext performBlockAndWait:^{
        NSError *error;
        if (![self.searchFRC performFetch:&error]) {
            NSLog(@"Failed to perform search fetch: %@", error);
        }
        // 不刷新 
    }];
}
@end
