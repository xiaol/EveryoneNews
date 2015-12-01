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
#import "AccountTool.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "LPHttpTool.h"

static const CGFloat  padding=10;
static const CGFloat  HeaderViewHeight= 44;

@interface LPComposeViewController () <UITextViewDelegate>
{
    // 评论类别（1 分段评论 2 全文评论）
    NSString *commentTypeKey;
    // 全文评论内容
    NSString *fullTextComment;
}
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
    double btnWidth= 44;
    headerView.backgroundColor = self.color;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets=UIEdgeInsetsMake(0,0,0,10);
    [headerView addSubview:backBtn];
    
    UIButton *composeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    composeBtn.enabled = NO;
    composeBtn.centerX = ScreenWidth - composeBtn.width / 2 - padding;
    composeBtn.centerY = headerView.centerY;
    composeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    composeBtn.tag = self.commentType;
    [composeBtn addTarget:self action:@selector(composeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [composeBtn setTitle:@"发表" forState:UIControlStateNormal];
    composeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
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
    if(iPhone6Plus)
    {
        textView.y = 50;
    }
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    if (self.draftText.length) {
        textView.placehoderLabel.hidden = YES;
        textView.text = self.draftText;
    } else {
        textView.placehoderLabel.hidden = NO;
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
- (void)composeBtnClicked:(UIButton *)sender
{
    if (self.returnTextBlock != nil) {
        // 点击发送，取回评论文字，由详情页进行进一步处理（request）
        self.returnTextBlock(self.textView.text);
    }
    // 分段评论
    if(sender.tag == 1) {
        [noteCenter postNotificationName:LPCommentDidComposeNotification object:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(sender.tag == 2) {
        [self didComposefulltextComment];
    }
}

- (void)didComposefulltextComment {
    Account *account = [AccountTool account];
    // 1.1 创建comment对象
    LPComment *comment = [[LPComment alloc] init];
    comment.srcText = self.textView.text;
    comment.type = @"text_doc";
    comment.uuid = account.userId;
    comment.userIcon = account.userIcon;
    comment.userName = account.userName;
    comment.createTime = [NSString stringFromNowDate];
    comment.up = @"0";
    comment.isPraiseFlag = @"0";
    
    // 2. 发送post请求
    NSString *url = [NSString stringWithFormat:@"%@/news/baijia/point", ServerUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sourceUrl"] = self.sourceURL;
    params[@"srcText"] = comment.srcText;
    params[@"paragraphIndex"] = @"0";
    params[@"type"] = comment.type;
    params[@"uuid"] = comment.uuid;
    params[@"userIcon"] = comment.userIcon;
    params[@"userName"] = comment.userName;
    params[@"desText"]  = @"";
    [LPHttpTool postWithURL:url params:params success:^(id json) {
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:@"发表成功"];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发表失败"];
    }];
    
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
