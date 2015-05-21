//
//  AbsDatasource.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/17.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbsDatasource : NSObject

@property (nonatomic, copy) NSString *absStr;

+(id)absDatasourceWithStr:(NSString *)absStr;

@end
