//
//  LPRegisterViewController.m
//  EveryoneNews
//
//  Created by dongdan on 16/9/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPRegisterViewController.h"
#import "LPHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "LPValidateTool.h"
#import "MJExtension.h"

@interface LPRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;


@end

@implementation LPRegisterViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}


#pragma mark - setupSubViews
- (void)setupSubViews {
       self.view.backgroundColor = [UIColor colorFromHexString:LPColor9];
    
    // 导航栏
    double topViewHeight = TabBarHeight + StatusBarHeight + 0.5;
    double padding = 15;
    
    double returnButtonWidth = 13;
    double returnButtonHeight = 22;
    
    if (iPhone6Plus) {
        returnButtonWidth = 12;
        returnButtonHeight = 21;
    }
    if (iPhone6) {
        topViewHeight = 72;
    }
    double returnButtonPaddingTop = (topViewHeight - returnButtonHeight + StatusBarHeight) / 2;
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
    titleLabel.text = @"注册";
    titleLabel.textColor = [UIColor colorFromHexString:LPColor7];
    titleLabel.font = [UIFont  boldSystemFontOfSize:LPFont8];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.centerX = topView.centerX;
    titleLabel.centerY = backButton.centerY;
    [topView addSubview:titleLabel];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth , 0.5)];
    seperatorView.backgroundColor = [UIColor colorFromHexString:LPColor10];
    [self.view addSubview:seperatorView];
    
    CGFloat textFieldAdditionalHeight = 20;
    // 用户名
    NSString *usernamePlaceHolder = @"用户名 (5~20个字符,由字母和数字组成)";
    CGFloat userNameFontSize = 15;
    CGFloat usernameTextFieldX = 32;
    CGFloat usernameTextFieldW = ScreenWidth - usernameTextFieldX * 2;
    CGFloat usernameTextFieldY = CGRectGetMaxY(seperatorView.frame) + 30 - textFieldAdditionalHeight;
    CGFloat usernameTextFieldH = [usernamePlaceHolder sizeWithFont:[UIFont systemFontOfSize:userNameFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height + textFieldAdditionalHeight;
    UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(usernameTextFieldX, usernameTextFieldY, usernameTextFieldW, usernameTextFieldH)];
    usernameTextField.font = [UIFont systemFontOfSize:userNameFontSize];
    //1. Create Attributed text from your text field placeholder
    NSMutableAttributedString *usernameAttributedText = [[NSMutableAttributedString alloc] initWithString:usernamePlaceHolder];
    [usernameAttributedText addAttribute:NSFontAttributeName
                                   value:[UIFont systemFontOfSize:userNameFontSize]
                                   range:NSMakeRange(0, 3)];
    //2. Change Font size only
    [usernameAttributedText addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:LPFont6]
                           range:NSMakeRange(3, usernamePlaceHolder.length - 3)];
    usernameTextField.attributedPlaceholder = usernameAttributedText;
    usernameTextField.delegate = self;
    usernameTextField.textColor = [UIColor colorFromHexString:LPColor7];
    usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [self.view addSubview:usernameTextField];
    self.usernameTextField = usernameTextField;
    
    CAShapeLayer *usernameLayer = [CAShapeLayer layer];
    usernameLayer.frame = CGRectMake(usernameTextFieldX, usernameTextFieldY + usernameTextFieldH + 8, usernameTextFieldW, 0.5f);
    usernameLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
    [self.view.layer addSublayer:usernameLayer];
    
    // 邮箱
    NSString *emailPlaceHolder = @"电子邮箱";
    CGFloat emailTextFieldX = usernameTextFieldX;
    CGFloat emailTextFieldW = usernameTextFieldW;
    CGFloat emailTextFieldH = usernameTextFieldH;
    CGFloat emailTextFieldY = CGRectGetMaxY(usernameLayer.frame) + 30 - textFieldAdditionalHeight;
    UITextField *emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(emailTextFieldX, emailTextFieldY, emailTextFieldW, emailTextFieldH)];
    emailTextField.textColor = [UIColor colorFromHexString:LPColor7];
    emailTextField.font = [UIFont systemFontOfSize:userNameFontSize];
    emailTextField.placeholder = emailPlaceHolder;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.delegate = self;
    emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [self.view addSubview:emailTextField];
    self.emailTextField = emailTextField;

    CAShapeLayer *emailLayer = [CAShapeLayer layer];
    emailLayer.frame = CGRectMake(emailTextFieldX, emailTextFieldY + emailTextFieldH + 8, emailTextFieldW, 0.5f);
    emailLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
    [self.view.layer addSublayer:emailLayer];
    
    // 密码
    NSString *passwordPlaceHolder = @"密码 (6~20位)";
    CGFloat passwordTextFieldX = usernameTextFieldX;
    CGFloat passwordTextFieldW = usernameTextFieldW;
    CGFloat passwordTextFieldH = usernameTextFieldH;
    CGFloat passwordTextFieldY = CGRectGetMaxY(emailLayer.frame) + 30 - textFieldAdditionalHeight;
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordTextFieldX, passwordTextFieldY, passwordTextFieldW, passwordTextFieldH)];
    passwordTextField.font = [UIFont systemFontOfSize:userNameFontSize];
    //1. Create Attributed text from your text field placeholder
    NSMutableAttributedString *passwordAttributedText = [[NSMutableAttributedString alloc] initWithString:passwordPlaceHolder];
    [passwordAttributedText addAttribute:NSFontAttributeName
                                   value:[UIFont systemFontOfSize:userNameFontSize]
                                   range:NSMakeRange(0, 2)];
    //2. Change Font size only
    [passwordAttributedText addAttribute:NSFontAttributeName
                                   value:[UIFont systemFontOfSize:LPFont6]
                                   range:NSMakeRange(3, passwordPlaceHolder.length - 3)];
    passwordTextField.attributedPlaceholder = passwordAttributedText;
    passwordTextField.textColor = [UIColor colorFromHexString:LPColor7];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [self.view addSubview:passwordTextField];
    self.passwordTextField = passwordTextField;
    
    
    CAShapeLayer *passwordLayer = [CAShapeLayer layer];
    passwordLayer.frame = CGRectMake(passwordTextFieldX, passwordTextFieldY + passwordTextFieldH + 8, passwordTextFieldW, 0.5f);
    passwordLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
    [self.view.layer addSublayer:passwordLayer];

    // 注册
    NSString *registerButtonTitle = @"注册";
    CGFloat registerButtonFontSize = LPFont4;
    CGFloat registerButtonX = usernameTextFieldX;
    CGFloat registerButtonW = usernameTextFieldW;
    CGFloat registerButtonH = 44;
    CGFloat registerButtonY = CGRectGetMaxY(passwordLayer.frame) + 29;
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(registerButtonX, registerButtonY, registerButtonW, registerButtonH)];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:registerButtonFontSize];
    [registerButton setTitle:registerButtonTitle forState:UIControlStateNormal];
    [registerButton setTitleColor: [UIColor colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor colorFromHexString:LPColor25];
    registerButton.layer.cornerRadius = 3;
    registerButton.clipsToBounds = YES;
    [registerButton addTarget:self action:@selector(registerButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
}


#pragma mark - 返回
- (void)backButtonDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        BOOL emailFormat = [LPValidateTool validateEmail:self.emailTextField.text];
        if (emailFormat) {
            [self.emailTextField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
        } else {
            [MBProgressHUD showError:@"邮箱格式错误"];
        }
    } else {
        [self.usernameTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.usernameTextField || textField == self.passwordTextField) {
        if (textField.text.length >= 20 && range.length == 0) {
            return NO;
        }
    }
    return YES;
}



#pragma mark - 注册
- (void)registerButtonDidClick {
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0 && self.emailTextField.text.length > 0) {
        BOOL emailFormat = [LPValidateTool validateEmail:self.emailTextField.text];
        if (emailFormat) {
            NSString *url = [NSString stringWithFormat:@"%@/v2/au/sin/l", ServerUrlVersion2];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"utype"] = @(1);
            params[@"platform"] = @(1);
            if ([userDefaults objectForKey:@"uid"] && [userDefaults objectForKey:@"utype"]) {
                params[@"uid"] = @([[userDefaults objectForKey:@"uid"] integerValue]);
            }
            params[@"uname"]  = self.usernameTextField.text;
            params[@"email"] =  self.emailTextField.text;
            params[@"password"] = self.passwordTextField.text;
            
            [LPHttpTool postJSONResponseAuthorizationWithURL:url params:params success:^(id json, NSString *authorization) {
                
                if ([json[@"code"] integerValue] == 2000) {
                    NSDictionary *dict = (NSDictionary *)json[@"data"];
                    [userDefaults setObject:dict[@"uid"] forKey:@"uid"];
                    [userDefaults setObject:@"1" forKey:@"uIconDisplay"];
                    [userDefaults setObject:dict[@"utype"] forKey:@"utype"];
                    [userDefaults setObject:authorization forKey:@"uauthorization"];
                    [userDefaults synchronize];
                    [MBProgressHUD showSuccess:@"注册成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if ([json[@"code"] integerValue] == 2003) {
                    [MBProgressHUD showError:@"邮箱已存在"];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        } else {
            [MBProgressHUD showError:@"邮箱格式错误"]; 
        }
        
        

    } else {
        [MBProgressHUD showError:@"请填写完整信息"];
    }

}





@end
