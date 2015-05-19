//
//  FormData.h
//  EveryoneNews
//
//  Created by apple on 15/5/12.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormData : NSObject

@property (nonatomic, strong) NSData *data;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *filename;

@property (nonatomic, copy) NSString *mimeType;

@end
