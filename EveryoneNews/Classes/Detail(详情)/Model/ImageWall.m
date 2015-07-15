//
//  ImageWall.m
//  EveryoneNews
//
//  Created by Feng on 15/7/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ImageWall.h"

@implementation ImageWall
-(NSString *)description{
    return [NSString stringWithFormat:@"<%p,%@> {img = %@,note = %@}",self,self.class,_img,_note];
}
@end
