//
//  WeiboCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboDatasource.h"
#import "BaseCell.h"

@interface WeiboCell : BaseCell<UIScrollViewDelegate>

@property (nonatomic, strong)WeiboDatasource *weiboDatasource;
@property (nonatomic, assign) CGFloat cellH;

@end
