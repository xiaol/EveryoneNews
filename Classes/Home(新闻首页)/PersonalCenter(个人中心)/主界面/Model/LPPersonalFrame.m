//
//  LPPersonalFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPPersonalFrame.h"
#import "LPPersonal.h"

const static CGFloat cellHeight = 58;
@implementation LPPersonalFrame

- (void)setPersonal:(LPPersonal *)personal {
    _personal = personal;
    CGFloat imageNameX = 23;
    CGFloat imageNameH = 22;
    CGFloat imageNameW = 22;
    
    if (iPhone5) {
        imageNameW = 20.0f;
        imageNameH = 20.0f;
    }
    CGFloat imageNameY = (cellHeight - imageNameH) / 2;

    _imageNameF = CGRectMake(imageNameX, imageNameY, imageNameW, imageNameH);
    
    CGFloat titleX = CGRectGetMaxX(_imageNameF) + 21;
    CGFloat titleH = cellHeight;
    CGFloat titleY = 0;
    CGFloat titleW = 100;
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat arrowW = 10;
    CGFloat arrowH = 15;
    if (iPhone5) {
        arrowW = 8;
        arrowH = 12;
    }
    CGFloat arrowX = (ScreenWidth - arrowW - 23);
    CGFloat arrowY = (cellHeight - arrowH) / 2;
    _arrowF = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    
    CGFloat seperatorLayerX = imageNameX;
    CGFloat seperatorLayerH = 0.5f;
    CGFloat seperatorLayerY = cellHeight - seperatorLayerH;
    CGFloat seperatorLayerW = ScreenWidth - seperatorLayerX;
    _seperatorLayerF = CGRectMake(seperatorLayerX, seperatorLayerY, seperatorLayerW, seperatorLayerH);
}

@end
