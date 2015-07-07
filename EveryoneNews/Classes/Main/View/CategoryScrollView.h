//
//  CategoryView.h
//  EveryoneNews
//
//  Created by Feng on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCategory.h"

typedef void (^categoryBtnClick)(LPCategory *from,LPCategory *to);

@interface CategoryScrollView : UIScrollView

- (void)didCategoryBtnClick:(categoryBtnClick)block;

@end
