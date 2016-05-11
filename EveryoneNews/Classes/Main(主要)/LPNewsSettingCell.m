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

NS_ASSUME_NONNULL_BEGIN

#define kTextFont [UIFont systemFontOfSize:36.f/fontSizePxToSystemMultiple]

@implementation LPNewsSettingCell{
    
    UIImageView *leftImageView;
    UILabel *textLabel;
    UIImageView *rightImageView;
    UILabel *signOutLabel;
    CALayer *lineLayer;
    UILabel *noticeLabel;
}

- (nonnull instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        leftImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:leftImageView];
        rightImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:rightImageView];
        
        textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:textLabel];
        textLabel.font = kTextFont;
        textLabel.textColor = [UIColor colorWithDesignIndex:1];
        textLabel.highlightedTextColor = [UIColor colorWithDesignIndex:1];
        self.contentView.backgroundColor = self.backgroundColor;
        textLabel.backgroundColor = self.backgroundColor;
        
        signOutLabel = [[UILabel alloc] init];
        [self.contentView addSubview:signOutLabel];
        signOutLabel.font = kTextFont;
        signOutLabel.textColor = [UIColor colorWithDesignIndex:2];
        signOutLabel.backgroundColor = self.backgroundColor;
        signOutLabel.textAlignment = NSTextAlignmentCenter;
        
        
        CGRect lineLayerRect = CGRectMake(59.f, kSetingCellHeight-1.f, kApplecationScreenWidth-59.f, 1.f);
        lineLayer = [CALayer layer];
        lineLayer.frame = lineLayerRect;
        lineLayer.backgroundColor = [[UIColor colorWithDesignIndex:5] CGColor];
        [self.contentView.layer addSublayer:lineLayer];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = self.backgroundColor;
        self.backgroundView = backgroundView;
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor colorWithDesignIndex:5];
        self.selectedBackgroundView = selectedBackgroundView;
        
        noticeLabel = [[UILabel alloc] init];
        noticeLabel.text = @"关闭时，你可能错过重要资讯通知";
        noticeLabel.backgroundColor = self.backgroundColor;
        noticeLabel.font = [UIFont systemFontOfSize:24/fontSizePxToSystemMultiple];
        noticeLabel.textColor = [UIColor colorWithDesignIndex:11];
        noticeLabel.highlightedTextColor = [UIColor colorWithDesignIndex:11];
        [self.contentView addSubview:noticeLabel];

    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
}


static const CGFloat kLeftMargin = 14.f;

- (void)setModel:(nonnull id)model IndexPath:(nullable NSIndexPath *)indexPath {
    if (model && [model isKindOfClass:[NSDictionary class]]) {
        __weak __typeof(self)weakSelf = self;
        __weak __typeof(leftImageView)weakLeftImageView = leftImageView;
        NSDictionary *dict = (NSDictionary *)model;
        NSString *keyStr = [dict.allKeys objectAtIndex:0];
        
        if (indexPath.section != 3) {
            leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",keyStr]];
            textLabel.text = [dict.allValues objectAtIndex:0];
            
            [leftImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
                make.centerY.equalTo(strongSelf.mas_centerY);
                make.left.mas_equalTo(@(kLeftMargin));
                make.size.mas_equalTo(strongLeftImageView.image.size);
            }];
            
            if (indexPath.section == 0 && indexPath.row ==1) {
                
                [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
                    make.top.equalTo(strongSelf.contentView.mas_top).with.offset((73-textLabel.size.height-10-noticeLabel.size.height-38)/2);
                    make.left.equalTo(strongLeftImageView.mas_right).with.mas_offset(@20);
                    make.size.mas_equalTo(CGSizeMake(180.f, (kTextFont).lineHeight));
                }];
                
                [noticeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
                    make.top.equalTo(textLabel.mas_bottom).with.offset(10);
                    make.left.equalTo(strongLeftImageView.mas_right).with.mas_offset(@20);
                }];
            }else{
                [textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    __strong __typeof(weakLeftImageView)strongLeftImageView = weakLeftImageView;
                    make.centerY.equalTo(strongSelf.mas_centerY);
                    make.left.equalTo(strongLeftImageView.mas_right).with.mas_offset(@20);
                    make.size.mas_equalTo(CGSizeMake(180.f, (kTextFont).lineHeight));
                }];
            }
        
            [signOutLabel removeFromSuperview];
        }else{
            Account *account = [AccountTool account];
            if (account == nil) {
                signOutLabel.text = @"点击登录";
            }else{
                signOutLabel.text = [dict.allValues objectAtIndex:0];
            }
            
            [signOutLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                make.center.equalTo(strongSelf.contentView);
                make.size.mas_equalTo(CGSizeMake(180.f, [UIFont systemFontOfSize:20.f].lineHeight));
            }];
            
            [leftImageView removeFromSuperview];
            [textLabel removeFromSuperview];
            [self.infoPushSwitchBtn removeFromSuperview];
            [rightImageView removeFromSuperview];
            [self.fontSizeCtrBtn removeFromSuperview];
            [noticeLabel removeFromSuperview];
        }
        
        if (indexPath.section == 1) {
            [rightImageView removeFromSuperview];
            [noticeLabel removeFromSuperview];
            [self.infoPushSwitchBtn removeFromSuperview];
            [self.fontSizeCtrBtn removeFromSuperview];
        }
        
        if (indexPath.section == 2) {
            [noticeLabel removeFromSuperview];
            [self.infoPushSwitchBtn removeFromSuperview];
            [self.fontSizeCtrBtn removeFromSuperview];
            
            __weak __typeof(rightImageView)weakRightImageView = rightImageView;
            rightImageView.image = [UIImage imageNamed:@"DoubleArrow"];
            [rightImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                __strong __typeof(weakRightImageView)strongRightImageView = weakRightImageView;
                make.centerY.equalTo(strongSelf.mas_centerY);
                make.right.mas_equalTo(@(-14));
                make.size.mas_equalTo(strongRightImageView.image.size);
            }];
        }
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [rightImageView removeFromSuperview];
                [self.contentView addSubview:self.fontSizeCtrBtn];
                [self.fontSizeCtrBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    __weak typeof(weakSelf)strongSelf = weakSelf;
                    make.centerY.equalTo(strongSelf.mas_centerY);
                    make.right.mas_equalTo(@(-14));
                    make.size.mas_equalTo(CGSizeMake(51.f*3, 36.f));
                }];
                [self.fontSizeCtrBtn addTarget:self action:@selector(modifyTextFontSize:) forControlEvents:(UIControlEventValueChanged)];
            }else{
                [rightImageView removeFromSuperview];
                [self.fontSizeCtrBtn removeFromSuperview];

                [self.contentView addSubview:self.infoPushSwitchBtn];
                [self.infoPushSwitchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    __weak typeof(weakSelf)strongSelf = weakSelf;
                    make.centerY.equalTo(strongSelf.mas_centerY);
                    make.right.mas_equalTo(@(-14));
                    make.size.mas_equalTo(CGSizeMake(51.f, 31.f));
                }];
                [self.infoPushSwitchBtn addTarget:self action:@selector(changeInfoPushStatus:) forControlEvents:UIControlEventValueChanged];
            }
        }
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            CGRect lineLayerRect = CGRectMake(0, kSetingCellHeight+22.f-1.f, kApplecationScreenWidth, 1.f);
            lineLayer.frame = lineLayerRect;
        }
        
        if (indexPath.section == 1) {
            
            CGRect lineLayerRect = CGRectMake(0, kSetingCellHeight-1.f, kApplecationScreenWidth, 1.f);
            lineLayer.frame = lineLayerRect;
        }
        
        if (indexPath.section == 2 && indexPath.row == 2) {
            
            CGRect lineLayerRect = CGRectMake(0, kSetingCellHeight-1.f, kApplecationScreenWidth, 1.f);
            lineLayer.frame = lineLayerRect;
        }
        
        if (indexPath.section == 3) {
            
            CGRect lineLayerRect = CGRectMake(0, kSetingCellHeight-1.f, kApplecationScreenWidth, 1.f);
            lineLayer.frame = lineLayerRect;
        }
    }
}

#pragma mark- private methods

- (void)modifyTextFontSize:(UISegmentedControl *)sender{
    
    if (sender.selectedSegmentIndex == 0) {
        self.homeViewFontSize = iPhone5HomeTitleSizeStandard;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeStandard;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeStandard;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeStandard;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeStandard;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeStandard;
        
        if (iPhone6Plus) {
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeStandard;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeStandard;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeStandard;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeStandard;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeStandard;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeStandard;
        }
        self.fontSizeType = @"standard";
        
    } else if (sender.selectedSegmentIndex == 1) {
        self.homeViewFontSize = iPhone5HomeTitleSizeLarger;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeLarger;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeLarger;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeLarger;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeLarger;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeLarger;
    
        if (iPhone6Plus) {
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeLarger;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeLarger;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeLarger;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeLarger;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeLarger;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeLarger;
        }
        self.fontSizeType = @"larger";
    } else if (sender.selectedSegmentIndex == 2) {
        self.homeViewFontSize = iPhone5HomeTitleSizeSuperLarger;
        self.currentDetailContentFontSize = iPhone5DetailContentSizeSuperLarger;
        self.currentDetaiTitleFontSize  = iPhone5DetailTitleSizeSuperLarger;
        self.currentDetailCommentFontSize = iPhone5DetailCommentSizeSuperLarger;
        self.currentDetailRelatePointFontSize = iPhone5DetailRelateSizeSuperLarger;
        self.currentDetailSourceFontSize = iPhone5DetailSourceSizeSuperLarger;
        
        if (iPhone6Plus) {
            
            self.homeViewFontSize = iPhone6PlusHomeTitleSizeSuperLarger;
            self.currentDetailContentFontSize = iPhone6PlusDetailContentSizeSuperLarger;
            self.currentDetaiTitleFontSize  = iPhone6PlusDetailTitleSizeSuperLarger;
            self.currentDetailCommentFontSize = iPhone6PlusDetailCommentSizeSuperLarger;
            self.currentDetailRelatePointFontSize = iPhone6PlusDetailRelateSizeSuperLarger;
            self.currentDetailSourceFontSize = iPhone6PlusDetailSourceSizeSuperLarger;
        }
        self.fontSizeType = @"superlarger";
        
    }
    
    [LPFontSizeManager sharedManager].currentHomeViewFontSize = self.homeViewFontSize;
    [LPFontSizeManager sharedManager].currentHomeViewFontSizeType = self.fontSizeType;
    [LPFontSizeManager sharedManager].currentDetailContentFontSize = self.currentDetailContentFontSize;
    [LPFontSizeManager sharedManager].currentDetaiTitleFontSize = self.currentDetaiTitleFontSize;
    [LPFontSizeManager sharedManager].currentDetailCommentFontSize = self.currentDetailCommentFontSize;
    [LPFontSizeManager sharedManager].currentDetailRelatePointFontSize = self.currentDetailRelatePointFontSize;
    [LPFontSizeManager sharedManager].currentDetailSourceFontSize = self.currentDetailSourceFontSize;
    
    [[LPFontSizeManager sharedManager] saveHomeViewFontSizeAndType];
    
    [noteCenter postNotificationName:LPFontSizeChangedNotification object:nil];
    
    
    
}

- (void)changeInfoPushStatus:(UISwitch *)sender{
    if (sender.on) {
//        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
//        
//        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//        
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        NSURL *urlStr = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
            [[UIApplication sharedApplication] openURL:urlStr];
        }
        
        NSLog(@"打开推送");
    }else{
//        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        NSLog(@"关闭推送");
        
        NSURL *urlStr = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
            [[UIApplication sharedApplication] openURL:urlStr];
        }
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}

#pragma mark- Getters and Setters

- (UISegmentedControl *)fontSizeCtrBtn{
    if (!_fontSizeCtrBtn) {
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"标准",@"大",@"超大",nil];
        UISegmentedControl *btn = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        btn.tintColor = [UIColor colorWithDesignIndex:5];
        
        
        NSString *fontSizeType = [LPFontSizeManager sharedManager].currentHomeViewFontSizeType;
        if ([fontSizeType isEqualToString:@"standard"]) {
            btn.selectedSegmentIndex = 0;
        } else if ([fontSizeType isEqualToString:@"larger"]) {
            btn.selectedSegmentIndex = 1;
        } else if ([fontSizeType isEqualToString:@"superlarger"]) {
            btn.selectedSegmentIndex = 2;
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:16.f],NSFontAttributeName,nil];
        [btn setTitleTextAttributes:dic forState:UIControlStateSelected];
        
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:16.f],NSFontAttributeName,nil];
        [btn setTitleTextAttributes:dic1 forState:UIControlStateNormal];
        _fontSizeCtrBtn = btn;
    }
    return _fontSizeCtrBtn;
}

- (UISwitch *)infoPushSwitchBtn{
    if (!_infoPushSwitchBtn) {
        UISwitch *btn = [[UISwitch alloc] init];
        _infoPushSwitchBtn = btn;
    }
    [_infoPushSwitchBtn setOn:NO];
    
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types !=UIUserNotificationTypeNone){
        
        [_infoPushSwitchBtn setOn:YES];
    }
    return _infoPushSwitchBtn;
}


@end
NS_ASSUME_NONNULL_END