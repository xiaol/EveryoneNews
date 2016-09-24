//
//  LPPersonal.h
//  EveryoneNews
//
//  Created by dongdan on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPersonal : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

-(instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title;

@end
