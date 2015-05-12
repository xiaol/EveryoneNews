//
//  HeadViewCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/3/23.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadViewFrame.h"
#import "BaseFeedCell.h"

//@protocol HeadViewDelegate <NSObject>
//
//@required
//
//- (void)getTextContent:(NSString *)sourceUrl
//                imgUrl:(NSString *)imgUrl
//            SourceSite:(NSString *)sourceSite
//                Update:(NSString *)update
//                 Title:(NSString *)title
//          ResponseUrls:(NSArray *)responseUrls
//             RootClass:(NSString *)rootClass
//                hasImg:(BOOL)hasImg;
//
//@end

@interface HeadViewCell : BaseFeedCell

@property (nonatomic, strong)HeadViewFrame *headViewFrm;

//@property (nonatomic, strong)id<HeadViewDelegate>delegate;




@end
