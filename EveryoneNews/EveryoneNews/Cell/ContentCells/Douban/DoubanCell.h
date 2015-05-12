//
//  DoubanCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"
#import "DoubanDatasource.h"

@interface DoubanCell : BaseCell

@property (nonatomic, strong) DoubanDatasource *doubanDatasource;
@property (nonatomic, assign) CGFloat cellH;

@end
