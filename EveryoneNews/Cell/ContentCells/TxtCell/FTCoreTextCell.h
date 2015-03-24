//
//  FTCoreTextCell.h
//  upNews
//
//  Created by 于咏畅 on 15/3/6.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TxtDatasource.h"


@interface FTCoreTextCell : UITableViewCell

@property (nonatomic, strong) TxtDatasource *txtDatasource;
@property (nonatomic, assign) CGFloat cellH;

@end
