//
//  TxtDatasource.h
//  upNews
//
//  Created by 于咏畅 on 15/1/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TxtDatasource : NSObject

@property (nonatomic, copy) NSString *txtStr;

- (id)initWithTxtStr:(NSString *)txtStr;
+ (id)txtDatasourceWithTxtStr:(NSString *)txtStr;

@end
