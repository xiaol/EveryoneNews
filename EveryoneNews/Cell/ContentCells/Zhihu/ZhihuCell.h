//
//  ZhihuCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZhihuDatasource.h"
#import "BaseCell.h"

@interface ZhihuCell : BaseCell

@property (nonatomic, strong) ZhihuDatasource *zhihuDatasource;
@property (nonatomic, assign) CGFloat cellH;

@end