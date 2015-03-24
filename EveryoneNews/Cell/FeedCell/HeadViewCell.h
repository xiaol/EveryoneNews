//
//  HeadViewCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadViewFrame.h"

@protocol HeadViewDelegate <NSObject>

@required
- (void)getTextContent:(NSString *)sourceId
                imgUrl:(NSString *)imgUrl
            SourceSite:(NSString *)sourceSite
                Update:(NSString *)update
                 Title:(NSString *)title
             sourceUrl:(NSString *)sourceUrl
                hasImg:(BOOL)hasImg
              favorNum:(int)favorNum;

@end

@interface HeadViewCell : UITableViewCell

@property (nonatomic, strong)HeadViewFrame *headViewFrm;

@property (nonatomic, strong)id<HeadViewDelegate>delegate;

@end
