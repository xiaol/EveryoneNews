//
//  LPConcernIndroduceTableViewCell.m
//  EveryoneNews
//
//  Created by dongdan on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPConcernIndroduceTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "LPConcernIntroduceFrame.h"
#import "LPConcernIntroduce.h"

@interface LPConcernIndroduceTableViewCell ()

@property (nonatomic, strong) TTTAttributedLabel *introduceLabel;
@property (nonatomic, strong) UIView *introduceSeperatorLine;

@end
@implementation LPConcernIndroduceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        TTTAttributedLabel *introduceLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        introduceLabel.textColor = [UIColor colorFromHexString:@"#1a1a1a"];
        introduceLabel.numberOfLines = 0;
        introduceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:introduceLabel];
        self.introduceLabel = introduceLabel;
        
        UIView *introduceSeperatorLine = [[UIView alloc] init];
        introduceSeperatorLine.backgroundColor = [UIColor colorFromHexString:@"e4e4e4"];
        [self.contentView addSubview:introduceSeperatorLine];
        self.introduceSeperatorLine = introduceSeperatorLine;
    }
    return self;
}

- (void)setCardFrame:(LPConcernIntroduceFrame *)cardFrame {
    
    _cardFrame = cardFrame;
    self.introduceLabel.frame = self.cardFrame.introduceLabelFrame;
    self.introduceLabel.text = cardFrame.concernIntroduce.introduce;
    self.introduceSeperatorLine.frame = self.cardFrame.introduceSeperatorLineFrame;
    
}

@end
