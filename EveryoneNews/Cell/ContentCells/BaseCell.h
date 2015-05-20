//
//  BaseCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/1.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebDelegate <NSObject>

- (void)loadWebViewWithURL:(NSString *)URL;

@end

@interface BaseCell : UITableViewCell

@property (nonatomic, strong)id<WebDelegate>delegate;

- (void)showWebViewWithUrl:(NSString *)URL;

@end
