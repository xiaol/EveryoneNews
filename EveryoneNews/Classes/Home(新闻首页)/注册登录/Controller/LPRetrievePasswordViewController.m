//
//  LPRetrievePasswordViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPRetrievePasswordViewController.h"
#import "LPValidateTool.h"
#import "LPHttpTool.h"
#import "MBProgressHUD+MJ.h"

@interface LPRetrievePasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *emailPromptTextField;
@property (nonatomic, assign) BOOL legalEmailFormat;
@property (nonatomic, strong) UIButton *sendEmailButton;
@property (nonatomic, strong) UIView *promptView;

@end

@implementation LPRetrievePasswordViewController


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}


#pragma mark setupSubViews 
- (void)setupSubViews {
    self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    
    
    // 导航栏
    CGFloat topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    CGFloat padding = 15;
    
    CGFloat returnButtonWidth = 13;
    CGFloat returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    CGFloat returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topViewHeight)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#ffffff" alpha:0.0f];
    [self.view addSubview:topView];
    
    // 返回button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, returnButtonPaddingTop, returnButtonWidth, returnButtonHeight)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"消息中心返回"] forState:UIControlStateNormal];
    backButton.enlargedEdge = 15;
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"重置密码";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    // 电子邮箱
    CGFloat paddingLeft = 32;
    NSString *emailPlaceHolder = @"电子邮箱";
    CGFloat emailFontSize = 15;
    CGFloat emailTextFieldX = paddingLeft;
    CGFloat emailTextFieldW = ScreenWidth - emailTextFieldX * 2;
    CGFloat emailTextFieldH = 44;
    CGFloat emailTextFieldY =  CGRectGetMaxY(seperatorView.frame) + 30;
    UITextField *emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(emailTextFieldX, emailTextFieldY, emailTextFieldW, emailTextFieldH)];
    emailTextField.textColor = [UIColor colorFromHexString:LPColor3];
    emailTextField.font = [UIFont systemFontOfSize:emailFontSize];
    emailTextField.placeholder = emailPlaceHolder;
    emailTextField.backgroundColor = [UIColor whiteColor];
    emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    emailTextField.delegate = self;
    [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailTextField = emailTextField;
  
    [self.view addSubview:emailTextField];
    
    // 下一步
    NSString *sendEmailEmailButtonTitle = @"下一步";
    CGFloat sendEmailButtonFontSize = LPFont4;
    CGFloat sendEmailButtonX = paddingLeft;
    CGFloat sendEmailButtonW = ScreenWidth - sendEmailButtonX * 2;
    CGFloat sendEmailButtonH = 44;
    CGFloat sendEmailButtonY = CGRectGetMaxY(emailTextField.frame) + 20;
    UIButton *sendEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(sendEmailButtonX, sendEmailButtonY, sendEmailButtonW, sendEmailButtonH)];
    sendEmailButton.titleLabel.font = [UIFont systemFontOfSize:sendEmailButtonFontSize];
    [sendEmailButton setTitle:sendEmailEmailButtonTitle forState:UIControlStateNormal];
    [sendEmailButton setTitleColor: [UIColor colorFromHexString:LPColor3] forState:UIControlStateNormal];
    sendEmailButton.backgroundColor = [UIColor colorFromHexString:@"#cbcbcb"];
    [sendEmailButton addTarget:self action:@selector(sendEmailButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    sendEmailButton.layer.cornerRadius = 3;
    sendEmailButton.clipsToBounds = YES;
    sendEmailButton.enabled = NO;
    [self.view addSubview:sendEmailButton];
    self.sendEmailButton = sendEmailButton;
    
    // 提示信息
    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight + 2, ScreenWidth, ScreenHeight - topViewHeight - 2)];
    promptView.backgroundColor = [UIColor colorFromHexString:LPColor9];
    promptView.hidden = YES;
    [self.view addSubview:promptView];
    self.promptView = promptView;
    
    CGFloat promptLabelFontSize = 15;
    NSString *promptStr = @"已向您的邮箱发送了含有新密码的邮件";
    CGFloat promptLabelY = 50;
    CGFloat promptLabelW = [promptStr sizeWithFont:[UIFont systemFontOfSize:promptLabelFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].width;
    CGFloat promptLabelH = [promptStr sizeWithFont:[UIFont systemFontOfSize:promptLabelFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height;
    CGFloat promptLabelX = (ScreenWidth - promptLabelW) / 2;
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH)];
    promptLabel.text = promptStr;
    promptLabel.font = [UIFont systemFontOfSize:promptLabelFontSize];
    promptLabel.textColor = [UIColor colorFromHexString:LPColor7];
    
    CGFloat emailPromptTextFieldY = CGRectGetMaxY(promptLabel.frame) + 18;
    CGFloat emailPromptTextFieldH = [emailPlaceHolder sizeWithFont:[UIFont systemFontOfSize:LPFont5] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height + 20;
    UITextField *emailPromptTextField = [[UITextField alloc] initWithFrame:CGRectMake(promptLabelX, emailPromptTextFieldY, promptLabelW, emailPromptTextFieldH)];
    emailPromptTextField.textColor = [UIColor colorFromHexString:LPColor3];
    emailPromptTextField.font = [UIFont systemFontOfSize:LPFont5];
    emailPromptTextField.backgroundColor = [UIColor colorFromHexString:@"#cbcbcb"];
    emailPromptTextField.textAlignment = NSTextAlignmentCenter;
    self.emailPromptTextField = emailPromptTextField;
    
    [promptView addSubview:promptLabel];
    [promptView addSubview:emailPromptTextField];
    
    // 前往邮箱查看
    NSString *openEmailButtonTitle = @"前往邮箱查看";
    CGFloat openEmailButtonFontSize = LPFont4;
    CGFloat openEmailButtonX = paddingLeft;
    CGFloat openEmailButtonW = ScreenWidth - paddingLeft * 2;
    CGFloat openEmailButtonH = 44;
    CGFloat openEmailButtonY = CGRectGetMaxY(emailPromptTextField.frame) + 50;
    UIButton *openEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(openEmailButtonX, openEmailButtonY, openEmailButtonW, openEmailButtonH)];
    openEmailButton.titleLabel.font = [UIFont systemFontOfSize:openEmailButtonFontSize];
    [openEmailButton setTitle:openEmailButtonTitle forState:UIControlStateNormal];
    [openEmailButton setTitleColor: [UIColor colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
    openEmailButton.backgroundColor = [UIColor colorFromHexString:LPColor25];
    openEmailButton.layer.cornerRadius = 3;
    openEmailButton.clipsToBounds = YES;
    [openEmailButton addTarget:self action:@selector(openEmailButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [promptView addSubview:openEmailButton];
    
}

#pragma mark - 返回
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送邮件
- (void)sendEmailButtonDidClick {
    if (self.legalEmailFormat) {
        CGFloat emailPromptTextFieldW = [self.emailTextField.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ScreenWidth, ScreenHeight)].width;
        CGFloat emailPromptTextFieldX = (ScreenWidth - emailPromptTextFieldW) / 2;
        CGFloat emailPromptTextFieldY = self.emailPromptTextField.origin.y;
        CGFloat emailPromptTextFieldH = self.emailPromptTextField.size.height;
        CGRect emailPromptTextFieldFrame = CGRectMake(emailPromptTextFieldX, emailPromptTextFieldY, emailPromptTextFieldW, emailPromptTextFieldH);
        self.emailPromptTextField.frame = emailPromptTextFieldFrame;
        self.promptView.hidden = NO;
        self.emailPromptTextField.text =  self.emailTextField.text;
        NSString *url = [NSString stringWithFormat:@"%@/v2/au/lin/r", ServerUrlVersion2];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"email"] =  self.emailTextField.text;
        
        [LPHttpTool postJSONResponseAuthorizationWithURL:url params:params success:^(id json, NSString *authorization) {
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }
}

#pragma mark - 前往邮箱查看
- (void)openEmailButtonDidClick {
    // 拆分邮箱
    NSArray *emailArray = [self.emailPromptTextField.text componentsSeparatedByString:@"@"];
    NSString *suffix = emailArray[emailArray.count - 1];
    NSString *emailWebSite = [NSString stringWithFormat:@"https://mail.%@", suffix];
    [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:emailWebSite]];
}

#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.emailTextField) {
        BOOL emailFormat = [LPValidateTool validateEmail:self.emailTextField.text];
        if (emailFormat) {
            self.legalEmailFormat = YES;
            self.sendEmailButton.enabled = YES;
            [self.sendEmailButton setBackgroundColor:[UIColor colorFromHexString:LPColor25]];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField ) {
        BOOL emailFormat = [LPValidateTool validateEmail:self.emailTextField.text];
        if (emailFormat) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        } else {
            [MBProgressHUD showError:@"邮箱格式不正确"];
        }
  
    }
    return NO;
}







@end
