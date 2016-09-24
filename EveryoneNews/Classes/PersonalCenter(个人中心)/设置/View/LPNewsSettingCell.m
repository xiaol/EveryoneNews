//
//  LPNewsSettingCell.m
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPNewsSettingCell.h"
#import "Account.h"
#import "AccountTool.h"
#import "LPFontSizeManager.h"
#import "AppDelegate.h"
#import "LPNewsMineViewController.h"
#import "LPPersonalSettingFrame.h"
#import "LPPersonalSetting.h"
#import "LPFontSize.h"

@interface LPNewsSettingCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *signOutLabel;
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) CALayer *seperatorLayer;

@end

@implementation LPNewsSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:LPFont3];
        titleLabel.textColor = [UIColor colorFromHexString:LPColor1];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.hidden = YES;
        [self.contentView addSubview:arrowImageView];
        self.arrowImageView = arrowImageView;
        
        UILabel *signOutLabel = [[UILabel alloc] init];
        signOutLabel.font = [UIFont systemFontOfSize:LPFont3];
        signOutLabel.textColor = [UIColor colorFromHexString:LPColor2];
        signOutLabel.hidden = YES;
        signOutLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:signOutLabel];
        self.signOutLabel = signOutLabel;
      
        
        UISwitch *switchButton = [[UISwitch alloc] init];
        switchButton.hidden = YES;
        [switchButton addTarget:self action:@selector(switchButtonDidClick:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:switchButton];
        self.switchButton = switchButton;
        
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"标准",@"大",@"超大",nil];
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        segmentControl.userInteractionEnabled = YES;
        segmentControl.tintColor = [UIColor colorFromHexString:LPColor5];
        
        NSDictionary *selectedDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],
                             NSForegroundColorAttributeName,
                             [UIFont fontWithName:@"Helvetica" size:LPFont4],
                             NSFontAttributeName,nil];
        [segmentControl setTitleTextAttributes:selectedDict forState:UIControlStateSelected];

        NSDictionary *normalDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],
                              NSForegroundColorAttributeName,
                              [UIFont fontWithName:@"Helvetica" size:LPFont4],
                              NSFontAttributeName,nil];
        [segmentControl setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        segmentControl.hidden = YES;
        [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:segmentControl];
        self.segmentedControl = segmentControl;
        
        CALayer *seperatorLayer = [CALayer layer];
        seperatorLayer.backgroundColor = [[UIColor colorFromHexString:LPColor10] CGColor];
        [self.contentView.layer addSublayer:seperatorLayer];
        self.seperatorLayer = seperatorLayer;
        
        [self setDefaultSegmentValue];
        [self setDefaultSwitchValue];
    }
    return self;
}

- (void)setSettingFrame:(LPPersonalSettingFrame *)personalSettingFrame indexPath:(NSIndexPath *)indexPath {
    
    LPPersonalSetting *personalSetting = personalSettingFrame.personalSetting;
    
    if (indexPath.section == 0) {
        if ([personalSetting.identifier isEqualToString:@"fontSize"] ) {
            self.segmentedControl.frame = personalSettingFrame.segmentControlF;
            self.segmentedControl.hidden = NO;
        } else {
            self.switchButton.hidden = NO;
            self.switchButton.frame = personalSettingFrame.switchF;
        }
    
    }  else if (indexPath.section == 2) {
        self.arrowImageView.hidden = NO;
        self.arrowImageView.image = [UIImage imageNamed:@"个人中心设置展开"];
        self.arrowImageView.frame = personalSettingFrame.arrowF;
        
    } else if (indexPath.section == 3) {
        self.signOutLabel.frame = personalSettingFrame.signOutF;
        self.signOutLabel.hidden = NO;
        self.iconImageView.hidden = YES;
        self.titleLabel.hidden = YES;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, CGRectGetHeight(self.signOutLabel.frame) - 0.5f, ScreenWidth, 0.5);
        layer.borderWidth = 0.5f;
        layer.borderColor = [UIColor colorFromHexString:LPColor10].CGColor;
        [self.signOutLabel.layer addSublayer:layer];
        
        Account *account = [AccountTool account];
        if (account == nil) {
            self.signOutLabel.text = @"点击登录";
        } else {
            self.signOutLabel.text = @"退出登录";
        }
    }
    self.seperatorLayer.frame = personalSettingFrame.seperatorLayerF;
    
    self.iconImageView.image = [UIImage imageNamed:personalSetting.imageName];
    self.iconImageView.frame = personalSettingFrame.imageNameF;
    
    self.titleLabel.text = personalSetting.title;
    self.titleLabel.frame = personalSettingFrame.titleF;

}

#pragma mark - 默认字体
- (void)setDefaultSegmentValue {
    NSString *fontSizeType = [LPFontSizeManager sharedManager].lpFontSize.fontSizeType;
    if ([fontSizeType isEqualToString:@"standard"]) {
        self.segmentedControl.selectedSegmentIndex = 0;
    } else if ([fontSizeType isEqualToString:@"larger"]) {
        self.segmentedControl.selectedSegmentIndex = 1;
    } else if ([fontSizeType isEqualToString:@"superlarger"]) {
        self.segmentedControl.selectedSegmentIndex = 2;
    }
}

#pragma mark - 默认推送
- (void)setDefaultSwitchValue {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [self.switchButton setOn:YES];
    }
}


#pragma mark - segmentControlDidClick
-(void)segmentAction:(UISegmentedControl *) sender {
    if (sender.selectedSegmentIndex == 0) {
        [self setFontSizeStandard];
    } else if (sender.selectedSegmentIndex == 1) {
        [self setFontSizeLarger];
    } else if (sender.selectedSegmentIndex == 2) {
        [self setFontSizeSuperLarger];
    }
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
    [noteCenter postNotificationName:LPFontSizeChangedNotification object:nil];
}


#pragma mark -
- (void)switchButtonDidClick:(UISwitch *)sender {
    if (sender.on) {
        NSURL *urlStr = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
            [[UIApplication sharedApplication] openURL:urlStr];
        }
    } else {
        NSURL *urlStr = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
            [[UIApplication sharedApplication] openURL:urlStr];
        }
    }
}


#pragma mark - 改变字体大小
- (void)setFontSizeStandard {
    LPFontSize *lpFontSize = [[LPFontSize alloc] initWithFontSizeType:@"standard"];
    [LPFontSizeManager sharedManager].lpFontSize = lpFontSize;
}

- (void)setFontSizeLarger {
    LPFontSize *lpFontSize = [[LPFontSize alloc] initWithFontSizeType:@"larger"];
    [LPFontSizeManager sharedManager].lpFontSize = lpFontSize;
}

- (void)setFontSizeSuperLarger {
    LPFontSize *lpFontSize = [[LPFontSize alloc] initWithFontSizeType:@"superlarger"];
    [LPFontSizeManager sharedManager].lpFontSize = lpFontSize;
}

@end
