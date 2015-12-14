//
//  LPSortCollectionViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 15/12/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LPSortCollectionViewCell.h"
#import "LPChannelItem.h"

@interface LPSortCollectionViewCell ()

@property (nonatomic, strong) LPChannelItem *channelItem;

@end
@implementation LPSortCollectionViewCell

- (LPChannelItem *)channelItem {
    if(_channelItem == nil) {
        _channelItem = [[LPChannelItem alloc] init];
    }
    return _channelItem;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height)];
        self.contentLabel.center = self.contentView.center;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.numberOfLines = 1;
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        self.contentLabel.minimumScaleFactor = 0.1;
        [self.contentView addSubview:self.contentLabel];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"分类删除"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteButton];
        
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCellWithArray:(NSMutableArray *)dataMutableArray indexPath:(NSIndexPath*)indexPath selectedTitle:(NSString *)selectedTitle{
    self.indexPath = indexPath;
    self.contentLabel.hidden = NO;
    self.channelItem = dataMutableArray[indexPath.row];
    self.contentLabel.text = self.channelItem.channelName;
    if([self.contentLabel.text isEqualToString:selectedTitle]) {
        self.contentLabel.textColor = [UIColor redColor];
    } else {
        self.contentLabel.textColor = [UIColor grayColor];
    }
    if(indexPath.section == 0 && indexPath.row == 0) {
        self.contentLabel.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentLabel.layer.borderWidth = 0.0;
        self.contentLabel.layer.masksToBounds = YES;
        
    } else {
        self.contentLabel.layer.masksToBounds = YES;
        self.contentLabel.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentLabel.layer.borderWidth = 0.45;
        self.contentLabel.layer.cornerRadius = 10;
        self.contentLabel.layer.masksToBounds = YES;
    }
}


@end
