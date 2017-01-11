//
//  CoreDataCVC.m
//  EveryoneNews
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoreDataCVC.h"

@interface CoreDataCVC ()
@property (nonatomic, strong) NSMutableArray *objectChanges;
@end

@implementation CoreDataCVC
#define debug 1


- (NSMutableArray *)objectChanges {
    if (_objectChanges == nil) {
        _objectChanges = [NSMutableArray array];
    }
    return _objectChanges;
}

- (void)performFetch {
    if (self.frc) {
        [self.frc.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![self.frc performFetch:&error]) {
                NSLog(@"Failed to perform fetch: %@", error);
            }
            [self.collectionView reloadData];
        }];
    } else {
        NSLog(@"Failed to fetch, the fetched results controller is nil.");
    }
}

#pragma mark - collection view datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.frc.sections objectAtIndex:section] numberOfObjects];
}

#pragma mark - frc delegate
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            dict[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            dict[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            dict[@(type)] = @[indexPath, newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            dict[@(type)] = indexPath;
            break;
        default:
            break;
    }
    [self.objectChanges addObject:dict];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([self.objectChanges count] > 0) {
        if ([self shouldReloadToPreventCollectionViewBUG] || self.collectionView.window == nil) {
            [self.collectionView reloadData];
        } else {
            [self.collectionView performBatchUpdates:^{
                for (NSDictionary *dict in self.objectChanges) {
                    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                        NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                        switch (type) {
                            case NSFetchedResultsChangeInsert:
                                [self.collectionView insertItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeDelete:
                                [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                                break;
                            case NSFetchedResultsChangeMove:
                                [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                                break;
                            case NSFetchedResultsChangeUpdate:
                                [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                                break;
                            default:
                                break;
                        }
                    }];
                }
            } completion:nil];
        }
    }
    [self.objectChanges removeAllObjects];
}

#pragma mark - collection view BUG inspection (虽然子类默认有default专辑, 为保证通用性, 仍然报告该BUG并处理)
- (BOOL)shouldReloadToPreventCollectionViewBUG {
    __block BOOL shouldReload = NO;
    for (NSDictionary *change in self.objectChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
            NSIndexPath *indexPath = obj;
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeDelete:
                    if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeUpdate:
                    shouldReload = NO;
                    break;
                case NSFetchedResultsChangeMove:
                    shouldReload = NO;
                    break;
            }
        }];
    }
    return shouldReload;
}

@end
