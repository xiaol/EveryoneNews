//
//  LPContentCell.h
//  EveryoneNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class LPContentFrame;

@class LPContent;
@class LPContentCell;
//@protocol LPContentCellDelegate <NSObject>
//
//@optional
//- (void)contentCell:(LPContentCell *)contentCell height:(CGFloat)height atRow:(NSInteger)row imageURL:(NSString *)imageURL;
//
//@end

@interface LPContentCell : UITableViewCell

@property (nonatomic, strong) LPContent *content;

@property (nonatomic, assign) NSInteger row;

@property(nonatomic ,assign) BOOL isLoad;
// 图片类型
@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//@property (nonatomic, weak) id<LPContentCellDelegate> delegate;

@end
