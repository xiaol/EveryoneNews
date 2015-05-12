//
//  ContentCell.h
//  upNews
//
//  Created by 于咏畅 on 15/1/21.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentCellFrame.h"

//@protocol ContentDelegate <NSObject>
//
//@required
//- (void)dataReload;
//
//@end
@interface ContentCell : UITableViewCell

@property (nonatomic, strong) ContentCellFrame *contentCellFrm;
@property (nonatomic, strong) UIImageView *img;

//@property (nonatomic, strong) id<ContentDelegate>delegate;

@end
