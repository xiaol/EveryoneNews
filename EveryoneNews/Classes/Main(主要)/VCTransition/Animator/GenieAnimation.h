//
//  GenieAnimation.h
//  EveryoneNews
//
//  Created by apple on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ModalTypePresent,
    ModalTypeDismiss
} ModalType;

@interface GenieAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) ModalType type;

@end
