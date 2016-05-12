//
//  Press+HTTP.h
//  EveryoneNews
//
//  Created by apple on 15/11/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Press.h"
@class LPHttpTool;

@interface Press (HTTP)
@property (nonatomic, strong) LPHttpTool *http;
- (void)cancelRequest;
@end
