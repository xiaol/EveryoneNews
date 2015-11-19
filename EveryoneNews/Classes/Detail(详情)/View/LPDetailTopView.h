//
//  LPDetailTopView.h
//  EveryoneNews
//
//  Created by dongdan on 15/11/19.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPDetailTopView;

@protocol LPDetailTopViewDelegate <NSObject>

-(void)topViewBackBtnClick;
-(void)shareBtnClick;
-(void)fulltextCommentBtnClick;

@end
@interface LPDetailTopView : UIView

@property (nonatomic, weak) id<LPDetailTopViewDelegate> delegate;

@end
