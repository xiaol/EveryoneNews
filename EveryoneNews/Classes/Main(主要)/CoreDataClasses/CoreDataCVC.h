//
//  CoreDataCVC.h
//  EveryoneNews
//
//  Created by apple on 15/10/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPBaseViewController.h"
#import "CoreDataHelper.h"

@interface CoreDataCVC : LPBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSFetchedResultsController *frc;

- (void)performFetch;
@end
