//
//  LPCollectToAlbumViewController.h
//  EveryoneNews
//
//  Created by apple on 15/10/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CoreDataCVC.h"

@interface LPCollectToAlbumViewController : CoreDataCVC
@property (nonatomic, copy) NSString *digText;
@property (nonatomic, strong) UIImage *snapshot;
@property (nonatomic, assign) BOOL fromPush;
@end
