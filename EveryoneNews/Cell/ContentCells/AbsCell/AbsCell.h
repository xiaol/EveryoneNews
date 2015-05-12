//
//  AbsCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/17.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbsDatasource.h"

@interface AbsCell : UITableViewCell

@property (nonatomic, strong)AbsDatasource *absDatasource;
@property (nonatomic, assign)CGFloat cellH;

@end
