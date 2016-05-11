//
//  QDNewsBaseViewController.h
//  EveryoneNews
//
//  Created by Yesdgq on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DoBaseRigthItemMethodBlock)(void);

@interface LPNewsBaseViewController : UIViewController

@property (nonatomic, strong ,nullable)UINavigationItem *navItem;
@property(nonatomic, readonly, assign)BOOL isRootLevel;
@property(nonatomic, readonly, assign)BOOL isPresent;
@property(nullable, nonatomic, copy) DoBaseRigthItemMethodBlock rigthItemMethodBlock;


#pragma mark- init

- (instancetype)initWithCustom;

- (instancetype)initWithRootCustom;

- (instancetype)initWithRoot;

- (instancetype)initWithPresent;

#pragma mark- InitNavItem

- (void)setNavItemWithTitle:(nullable NSString *)title  titleColor:(nullable NSString *)titileColor imageColor:(nullable NSString *)imageColor  hlImage:(nullable NSString *)hlImageColor  position:(NavItemPosition) position;

#pragma mark- SetItem

- (void)setCustomView:(UIView *)view position:(NavItemPosition) position;

- (void)setCustomViews:(NSArray *)viewArray position:(NavItemPosition) position;

- (void)backImageItem;

- (void)backItem:(NSString *)title;

- (void)setCancelItem;

- (void)setLeftItemWithTitle:(NSString *)title;

- (void)setLeftItemWithImage:(NSString *)imageName;

- (void)setLeftItemAdjoiningWithImage:(NSString *)imageName;

- (void)setRightItemWithTitle:(nullable NSString *)title;


- (void)setRightItemWithImage:(NSString *)imageName;

- (void)setNavTitleView:(NSString *)title;

#pragma mark- ItemMethod

- (void)doBackAction:(nullable id)sender;

- (void)leftItemAction:(nullable id)sender;

- (void)rightItemAction:(nullable id)sender;

#pragma mark- KeyBoard

- (void)enableKeyboardNSNotification:(BOOL)isEnable;

- (void)keyboardWillShow:(nullable NSNotification *)notification;

- (void)keyboardWillHide:(nullable NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END
