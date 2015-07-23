//
//  DiggerFooter.m
//  EveryoneNews
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "DiggerFooter.h"

@implementation DiggerFooter

-(void)prepare {
    [super prepare];
    
    NSMutableArray *refreshImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"动画3000%zd", i]];
        [refreshImages addObject:image];
    }
    
    [self setImages:refreshImages duration:0.5 forState:MJRefreshStateRefreshing];
}

@end
