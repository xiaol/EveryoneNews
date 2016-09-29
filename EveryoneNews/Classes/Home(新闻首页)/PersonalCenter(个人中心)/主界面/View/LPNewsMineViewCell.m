//
//  QDNewsMineViewCell.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsMineViewCell.h"
#import "LPNewsMineViewController.h"
#import "LPPersonalFrame.h"
#import "LPPersonal.h"

#define kTextFont [UIFont systemFontOfSize:36.f/fontSizePxToSystemMultiple]

@interface LPNewsMineViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) CALayer *seperatorLayer;

@end

@implementation LPNewsMineViewCell
 
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorFromHexString:LPColor14];
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor colorFromHexString:LPColor1];
        titleLabel.font = [UIFont systemFontOfSize:LPFont3];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:arrowImageView];
        self.arrowImageView = arrowImageView;
        
        CALayer *seperatorLayer = [CALayer layer];
        seperatorLayer.backgroundColor = [[UIColor colorFromHexString:LPColor10] CGColor];
        [self.contentView.layer addSublayer:seperatorLayer];
        self.seperatorLayer = seperatorLayer;
        
    }
    return self;
}

- (void)setPersonalFrame:(LPPersonalFrame *)personalFrame {
    _personalFrame = personalFrame;
    LPPersonal *person = personalFrame.personal;
    
    self.iconImageView.image = [UIImage imageNamed:person.imageName];
    self.iconImageView.frame = personalFrame.imageNameF;
    
    self.titleLabel.text = person.title;
    self.titleLabel.frame = personalFrame.titleF;
    
    self.arrowImageView.image = [UIImage imageNamed:@"个人中心展开"];
    self.arrowImageView.frame = personalFrame.arrowF;
    
    self.seperatorLayer.frame = personalFrame.seperatorLayerF;
    
    if ([person.title isEqualToString:@"消息中心"]) {
        self.seperatorLayer.hidden = YES;
    } else {
        self.seperatorLayer.hidden = NO;
    }
    
}

@end
