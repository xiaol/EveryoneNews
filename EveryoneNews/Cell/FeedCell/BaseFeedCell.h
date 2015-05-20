//
//  BaseFeedCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/22.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@protocol HeadViewDelegate <NSObject>

@required
- (void)getTextContent:(NSString *)sourceUrl
                imgUrl:(NSString *)imgUrl
            SourceSite:(NSString *)sourceSite
                Update:(NSString *)update
                 Title:(NSString *)title
          ResponseUrls:(NSArray *)responseUrls
             RootClass:(NSString *)rootClass
                hasImg:(BOOL)hasImg;

@optional
- (void)loadWebViewWithURL:(NSString *)URL;

@end

@interface BaseFeedCell : UITableViewCell

@property (nonatomic, strong)id<HeadViewDelegate>delegate;

- (void)showWebViewWithUrl:(NSString *)URL;

@end
