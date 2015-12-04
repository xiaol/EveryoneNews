//
//  LPHomeViewController.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPBaseViewController.h"
@class LPHomeViewController;
@protocol LPHomeViewControllerDelegate <NSObject>

- (void)moveMenuButtonWithIndex:(LPHomeViewController *)homeVc pageIndex:(int)pageIndex;

@end

@interface LPHomeViewController : LPBaseViewController

@property (nonatomic, weak) id<LPHomeViewControllerDelegate> delegate;

@end
