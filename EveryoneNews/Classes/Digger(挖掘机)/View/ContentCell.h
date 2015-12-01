//
//  ContentCell.h
//  EveryoneNews
//
//  Created by apple on 15/10/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentFrame;

@class ContentCell;
@protocol ContentCellDelegate <NSObject>

@optional
- (void)contentCell:(ContentCell *)contentCell didSavePhotoWithImageURL:(NSURL *)imageURL;
@end

@interface ContentCell : UITableViewCell
@property (nonatomic, strong) ContentFrame *contentFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<ContentCellDelegate> delegate;
@end
