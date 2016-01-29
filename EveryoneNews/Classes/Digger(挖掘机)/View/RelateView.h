//
//  RelateView.h
//  EveryoneNews
//
//  Created by dongdan on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RelateView;

@protocol RelateViewDelegate <NSObject>
@optional
-(void)relateView:(RelateView *)relateView didClickURL:(NSString *)url;
@end

@interface RelateView : UIView

@property (nonatomic, strong) NSArray *relateArray;

@property (nonatomic,weak) id<RelateViewDelegate> delegate;

@end
