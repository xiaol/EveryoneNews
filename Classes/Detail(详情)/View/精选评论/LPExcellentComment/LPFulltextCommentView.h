//
//  LPFulltextCommentView.h
//  EveryoneNews
//
//  Created by dongdan on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPFulltextCommentView : UIView

@property (nonatomic, strong) NSArray *fulltextCommentArray;

@property (nonatomic, assign) CGFloat totalHeight;
- (void)setFulltextCommentArray:(NSArray *)commentsArray;
@end
