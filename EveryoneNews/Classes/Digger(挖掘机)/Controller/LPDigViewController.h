//
//  LPDigViewController.h
//  EveryoneNews
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataCVC.h"

@interface LPDigViewController : CoreDataCVC
//@property (nonatomic, strong) NSMutableArray *hotwords;
@property (nonatomic, assign, getter=isPresented) BOOL presented;
@end
