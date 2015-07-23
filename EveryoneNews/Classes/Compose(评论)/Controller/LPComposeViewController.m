//
//  LPComposeViewController.m
//  EveryoneNews
//
//  Created by apple on 15/6/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LPComposeViewController.h"
#import "LPContent.h"
#import "LPTextView.h"
#import "MobClick.h"

#define padding 10
#define HeaderViewHeight 50

@interface LPComposeViewController () <UITextViewDelegate>
@property (nonatomic, strong) UIButton *composeBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) LPTextView *textView;
@end

@implementation LPComposeViewController
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupHeaderView];
    [self setupTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ComposeViewController"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ComposeViewController"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 叫出键盘
    [self.textView becomeFirstResponder];
}

- (void)returnText:(returnTextBlock)returnTextBlock
{
    self.returnTextBlock = returnTextBlock;
}

- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    [self.view addSubview:headerView];
    headerView.x = 0;
    headerView.y = 0;
    headerView.width = ScreenWidth;
    headerView.height = HeaderViewHeight;
    headerView.backgroundColor = self.color;
    
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.width = 60;
    backBtn.height = 20;
    backBtn.centerX = backBtn.width / 2 + 4;
    backBtn.centerY = headerView.centerY;
    backBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [backBtn setTitleColor:[UIColor colorFromHexString:ComposeButtonNormalColor] forState:UIControlStateNormal];
    [headerView addSubview:backBtn];
    
    UIButton *composeBtn = [[UIButton alloc] init];
    composeBtn.enabled = NO;
    composeBtn.width = 50;
    composeBtn.height = 20;
    composeBtn.centerX = ScreenWidth - composeBtn.width / 2 - padding;
    composeBtn.centerY = headerView.centerY;
    composeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [composeBtn addTarget:self action:@selector(composeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [composeBtn setTitle:@"发表" forState:UIControlStateNormal];
    composeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [composeBtn setTitleColor:[UIColor colorFromHexString:ComposeButtonNormalColor] forState:UIControlStateNormal];
    [composeBtn setTitleColor:LPColor(220, 220, 220) forState:UIControlStateDisabled];
    [headerView addSubview:composeBtn];
    self.composeBtn = composeBtn;
}

- (void)setupTextView
{
    LPTextView *textView = [[LPTextView alloc] init];
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.y = HeaderViewHeight;
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    if (self.draftText.length) {
        textView.placehoderLabel.hidden = YES;
        textView.text = self.draftText;
    } else {
        textView.placehoderLabel.hidden = NO;
#warning - 占位文字是神马？？？？？？
        textView.placehoder = @"没事说两句...";
    }
    textView.font = [UIFont systemFontOfSize:15];
    
    self.composeBtn.enabled = (self.textView.text.length != 0);

//    [noteCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [noteCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  返回
 */
- (void)backBtnClicked
{
    if (self.returnTextBlock != nil) {
        // 点击取消，保存草稿
        self.returnTextBlock(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  发表
 */
- (void)composeBtnClicked
{
    if (self.returnTextBlock != nil) {
        // 点击发送，取回评论文字，由详情页进行进一步处理（request）
        self.returnTextBlock(self.textView.text);
    }
    [noteCenter postNotificationName:LPCommentDidComposeNotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)keyboardWillShow:(NSNotification *)note
//{
//    // 键盘弹出时间
//    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView animateWithDuration:duration animations:^{
//        CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat keyboardHeight = keyboardFrame.size.height;
//        // ...
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)note
//{
//    
//}

#pragma mark - UITextViewDelegate
/**
 *  开始拖拽textView时退出键盘
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
/**
 *  监听文字变化，设置发表文字的enabled
 *
 *  @param textView textView
 */
- (void)textViewDidChange:(UITextView *)textView
{
    self.composeBtn.enabled = (textView.text.length != 0);
}

//- (void)dealloc
//{
//    [noteCenter removeObserver:self];
//}



@end
