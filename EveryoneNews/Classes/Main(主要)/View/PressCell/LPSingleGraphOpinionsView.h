//
//  LPSingleGraphOpinionsView.h
//  EveryoneNews
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LPPressFrame;
//@class LPSingleGraphOpinionsView;
//
//@protocol LPSingleGraphOpinionsViewDelegate <NSObject>
//@optional
//- (void)singleGraphOpinionsView:(LPSingleGraphOpinionsView *)singleGraphOpinionsView didClickURL:(NSString *)url;
//@end


@interface LPSingleGraphOpinionsView : UIView

@property (nonatomic, strong) NSArray *sublist;

+ (CGFloat)opinionsViewHeightWithOpinions:(NSArray *)sublist;

@end
