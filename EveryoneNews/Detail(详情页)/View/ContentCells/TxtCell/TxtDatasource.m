//
//  TxtDatasource.m
//  upNews
//
//  Created by 于咏畅 on 15/1/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import "TxtDatasource.h"

@implementation TxtDatasource

+ (id)txtDatasourceWithTxtStr:(NSString *)txtStr
{
    return [[TxtDatasource alloc] initWithTxtStr:txtStr];
}

- (id)initWithTxtStr:(NSString *)txtStr
{
    if (self = [super init]) {
        self.txtStr = txtStr;
    }
    return self;
}

@end
