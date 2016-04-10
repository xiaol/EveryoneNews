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
static const CGFloat  HeaderViewHeight = 64;
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
@property (nonatomic, strong) LPHttpTool *http;

@end

@implementation LPComposeViewController
- (BOOL)prefersStatusBarHidden
{
    return NO;
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
    double topViewHeight = 64;
    
    double backButtonWidth = 10;
    double backButtonHeight = 17;
    double backButtonPaddingTop = 33.5f;
    
    if(iPhone6Plus)
    {
        topViewHeight = 64;
        
        backButtonWidth = 11;
        backButtonHeight = 19;
        backButtonPaddingTop = 30.5f;
    }
    
    // 顶部视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
    [self.view addSubview:headerView];
    
    // 返回button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, backButtonPaddingTop, backButtonWidth, backButtonHeight)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"详情页返回"] forState:UIControlStateNormal];
    backBtn.enlargedEdge = 15;
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    double btnWidth= 44;
    
    // 分割线
    UILabel *seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, topViewHeight - 0.5, ScreenWidth, 0.5)];
    seperatorLabel.backgroundColor = [UIColor colorFromHexString:@"#cbcbcb"];
    [headerView addSubview:seperatorLabel];
    
    UIButton *composeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    composeBtn.enabled = NO;
    composeBtn.centerX = ScreenWidth - composeBtn.width / 2 - padding;
    composeBtn.centerY = backBtn.centerY;
    
    composeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    composeBtn.tag = self.commentType;
    [composeBtn addTarget:self action:@selector(composeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [composeBtn setTitle:@"发表" forState:UIControlStateNormal];
    composeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [composeBtn setTitleColor:[UIColor colorFromHexString:@"#747474"] forState:UIControlStateNormal];
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

#pragma mark - 发表评论
- (void)composeBtnClicked:(UIButton *)sender
{
    if (self.returnTextBlock != nil) {
        // 点击发送，取回评论文字，由详情页进行进一步处理（request）
        self.returnTextBlock(self.textView.text);
    }
    [self didComposefulltextComment];
}

- (void)didComposefulltextComment {
    Account *account = [AccountTool account];
    // 1.1 创建comment对象
    LPComment *comment = [[LPComment alloc] init];
    NSString *commentId =[[NSUUID UUID] UUIDString];
    comment.commentId = commentId;
    comment.srcText = self.textView.text;
    comment.uuid = account.userId;
    comment.userIcon = account.userIcon;
    comment.userName = account.userName;
    comment.createTime = [NSString stringFromNowDate];
    comment.color = [UIColor colorFromHexString:@"#747474"];
    comment.up = @"0";
    comment.isPraiseFlag = @"0";

    // 2. 发送post请求
    NSString *url = [NSString stringWithFormat:@"%@/bdp/news/comment/ydzx", ServerUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"comment_id"] = comment.commentId;
    params[@"content"] = comment.srcText;
    params[@"nickname"]  = comment.userName;
    params[@"uuid"] = comment.uuid;
    params[@"love"]  = @(0);
    params[@"create_time"]  = comment.createTime;
    params[@"profile"] = comment.userIcon;
    params[@"docid"] = self.docId;
    params[@"pid"] = @"";
    self.http = [LPHttpTool http];
    [self.http postJSONWithURL:url params:params success:^(id json) {
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(insertComment:)]) {
            comment.Id = [NSString stringWithFormat:@"%@", json[@"data"]];
            [self.delegate insertComment:comment];
        }
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
