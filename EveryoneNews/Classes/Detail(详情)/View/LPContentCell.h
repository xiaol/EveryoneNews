//
//  LPContentCell.h
//  EveryoneNews
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPContentFrame;
@class WKWebView;
@class LPContent;
@class LPContentCell;


@protocol LPContentCellDelegate <NSObject>

@optional

- (void)contentCell:(LPContentCell *)contentCell didOpenURL:(NSString *)url;

- (void)contentCell:(LPContentCell *)contentCell videoImageViewDidTapped:(NSString *)url webView:(WKWebView *)webView webViewF:(CGRect)webViewF;

- (void)contentCell:(LPContentCell *)contentCell selectedText:(NSString *)selectedText;

@end

@interface LPContentCell : UITableViewCell

@property (nonatomic, strong) LPContentFrame *contentFrame;

@property (nonatomic, assign) NSInteger row;



@property(nonatomic ,assign) BOOL isLoad;
// 图片类型
@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, weak) id<LPContentCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
