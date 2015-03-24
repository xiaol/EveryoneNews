//
//  ContentCellFrame.h
//  upNews
//
//  Created by 于咏畅 on 15/1/20.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentDatasource.h"

@interface ContentCellFrame : NSObject

@property (nonatomic, assign, readonly) CGRect imgViewFrm;
@property (nonatomic, assign, readonly) CGRect imgFrm;

@property (nonatomic, strong)ContentDatasource *contentDatasource;

@property (nonatomic, assign) CGFloat cellHeight;

@end
