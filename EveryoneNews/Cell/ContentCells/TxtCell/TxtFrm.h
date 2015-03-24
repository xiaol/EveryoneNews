//
//  TxtFrm.h
//  upNews
//
//  Created by 于咏畅 on 15/1/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TxtDatasource.h"

@interface TxtFrm : NSObject

@property (nonatomic, assign, readonly) CGRect txtFrm;
@property (nonatomic, assign, readonly) CGRect backgroundViewFrm;

@property (nonatomic, strong) TxtDatasource *txtDatasource;

@property (nonatomic, assign) CGFloat cellHeight;

@end
