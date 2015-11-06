//
//  Cover.h
//  EveryoneNews
//
//  Created by apple on 15/10/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cover : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isAddSign) BOOL addSign;
@end
