//
//  LPDetailContentFrame.h
//  EveryoneNews
//
//  Created by dongdan on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPDetailContent;
@interface LPDetailContentFrame : NSObject

@property (nonatomic, strong) LPDetailContent *content;
@property (nonatomic, assign) CGRect bodyLabelF;
@property (nonatomic, assign) CGRect photoViewF;

@property (nonatomic, assign) CGFloat cellHeight;


@end
