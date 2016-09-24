//
//  LPPersonalSetting.h
//  EveryoneNews
//
//  Created by dongdan on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPersonalSetting : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title imageName:(NSString *)imageName;

@end
