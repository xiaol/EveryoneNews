//
//  MoreCell.h
//  EveryoneNews
//
//  Created by 于咏畅 on 15/4/27.
//  Copyright (c) 2015年 yyc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreCellDelegate <NSObject>

- (void)scrollToPosition;

@end

@interface MoreCell : UITableViewCell

@property (nonatomic, assign)CGFloat cellH;

@property (nonatomic, strong)id <MoreCellDelegate>delegate;

@end
