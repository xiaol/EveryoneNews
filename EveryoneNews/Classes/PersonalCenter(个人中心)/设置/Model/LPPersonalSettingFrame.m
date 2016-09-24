//
//  LPPersonalSettingFrame.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPPersonalSettingFrame.h"
#import "LPPersonalSetting.h"

@implementation LPPersonalSettingFrame

- (void)setPersonalSetting:(LPPersonalSetting *)personalSetting {
    _personalSetting = personalSetting;
    CGFloat cellHeight = 44;
    if (iPhone6) {
        cellHeight = 51;
    }
    
    CGFloat imageNameX = 14;
    CGFloat imageNameH = 22.5f;
    CGFloat imageNameW = 24;
    
    CGFloat seperatorLayerX = imageNameX;
    CGFloat seperatorLayerH = 0.5f;
    CGFloat seperatorLayerY = cellHeight - seperatorLayerH;
    CGFloat seperatorLayerW = ScreenWidth - seperatorLayerX;
    
    CGFloat titleW = 100;
    if ([personalSetting.identifier isEqualToString:@"pushSetting"]) {
        imageNameW = 23;
        imageNameH = 25;
        seperatorLayerH = 0.0f;
        
    } else if ([personalSetting.identifier isEqualToString:@"clearCache"]) {
        imageNameW = 23;
        imageNameH = 25;
        seperatorLayerH = 0.0f;
    } else if ([personalSetting.identifier isEqualToString:@"about"]) {
        imageNameW = 25;
        imageNameH = 25;
    } else if ([personalSetting.identifier isEqualToString:@"privacy"]) {
        imageNameW = 21.5;
        imageNameH = 23;
    } else if ([personalSetting.identifier isEqualToString:@"appStore"]) {
        imageNameW = 23;
        imageNameH = 20;
        titleW = 150;
        seperatorLayerH = 0.0f;
    } else if ([personalSetting.identifier isEqualToString:@"signOut"]) {
        seperatorLayerH = 0.0f;
    }
    CGFloat imageNameY = (cellHeight - imageNameH) / 2;
    _imageNameF = CGRectMake(imageNameX, imageNameY, imageNameW, imageNameH);
    
    CGFloat titleX = CGRectGetMaxX(_imageNameF) + 20;
    CGFloat titleH = cellHeight;
    CGFloat titleY = 0;
   
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat arrowW = 9;
    CGFloat arrowH = 13;
    CGFloat arrowX = (ScreenWidth - arrowW - 14);
    CGFloat arrowY = (cellHeight - arrowH) / 2;
    _arrowF = CGRectMake(arrowX, arrowY, arrowW, arrowH);
    

    _seperatorLayerF = CGRectMake(seperatorLayerX, seperatorLayerY, seperatorLayerW, seperatorLayerH);
    
    _signOutF = CGRectMake(0, 0, ScreenWidth, cellHeight);
    
    CGFloat switchW = 51;
    CGFloat switchH = 31;
    CGFloat switchX = ScreenWidth - switchW - 14;
    CGFloat switchY = (cellHeight - switchH) / 2;
    _switchF = CGRectMake(switchX, switchY, switchW, switchH);
    
    CGFloat segmentControlW = 153;
    CGFloat segmentControlH = 36;
    CGFloat segmentControlX = ScreenWidth - 14 - segmentControlW;
    CGFloat segmentControlY = (cellHeight - segmentControlH) / 2;
    _segmentControlF = CGRectMake(segmentControlX, segmentControlY, segmentControlW, segmentControlH);
    
    
    
}

@end
