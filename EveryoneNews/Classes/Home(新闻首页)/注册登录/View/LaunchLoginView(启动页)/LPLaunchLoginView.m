//
//  LPFirstInstallationView.m
//  EveryoneNews
//
//  Created by dongdan on 16/4/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LPLaunchLoginView.h"
#import "LPHttpTool.h"
#import "LPValidateTool.h"
#import "MBProgressHUD+MJ.h"

const static CGFloat padding = 32;
@interface LPLaunchLoginView() <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation LPLaunchLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorFromHexString:LPColor9];
        // 关闭按钮
        CGFloat paddingTop = 37;
        CGFloat closeButtonW = 19;
        CGFloat closeButtonH = 19;
        CGFloat closeButtonX = ScreenWidth - closeButtonW - 15;
        CGFloat closeButtonY = paddingTop;
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(closeButtonX, closeButtonY, closeButtonW, closeButtonH)];
        closeButton.enlargedEdge = 10;
        [closeButton setBackgroundImage:[UIImage imageNamed:@"loginClose"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        // 登录标题
        NSString *loginTitle = @"登录";
        CGFloat loginTitleFontSize = 24;
        if (iPhone6Plus) {
            loginTitleFontSize = 25;
        }
        CGFloat loginLabelX = 0;
        CGFloat loginLabelY = 104;
        CGFloat loginLabelW = ScreenWidth;
        CGFloat loginLabelH = [loginTitle sizeWithFont:[UIFont systemFontOfSize:loginTitleFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height;
        
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(loginLabelX, loginLabelY, loginLabelW, loginLabelH)];
        loginLabel.text = loginTitle;
        loginLabel.font = [UIFont systemFontOfSize:loginTitleFontSize];
        loginLabel.textColor = [UIColor colorFromHexString:LPColor3];
        loginLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:loginLabel];
        
        CGFloat textFieldAdditionalHeight = 20;
        // 登录输入框
        NSString *usernamePlaceHolder = @"邮箱账号";
        CGFloat userNameFontSize = 15;
        CGFloat usernameTextFieldX = padding;
        CGFloat usernameTextFieldW = ScreenWidth - padding * 2;
        CGFloat usernameTextFieldY = CGRectGetMaxY(loginLabel.frame) + 59 - textFieldAdditionalHeight;
        CGFloat usernameTextFieldH = [usernamePlaceHolder sizeWithFont:[UIFont systemFontOfSize:userNameFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height + textFieldAdditionalHeight;
        
        // 用户名
        UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(usernameTextFieldX, usernameTextFieldY, usernameTextFieldW, usernameTextFieldH)];
        usernameTextField.placeholder = usernamePlaceHolder;
        usernameTextField.textColor = [UIColor colorFromHexString:LPColor7];
        usernameTextField.font = [UIFont systemFontOfSize:userNameFontSize];
        usernameTextField.delegate = self;
        usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [self addSubview:usernameTextField];
        self.usernameTextField = usernameTextField;
        
        CAShapeLayer *usernameLayer = [CAShapeLayer layer];
        usernameLayer.frame = CGRectMake(usernameTextFieldX, usernameTextFieldY + usernameTextFieldH + 8, usernameTextFieldW, 0.5f);
        usernameLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
        [self.layer addSublayer:usernameLayer];
        
        // 密码
        NSString *passwordPlaceHolder = @"密码";
        CGFloat passwordTextFieldX = usernameTextFieldX;
        CGFloat passwordTextFieldW = usernameTextFieldW;
        CGFloat passwordTextFieldH = usernameTextFieldH;
        CGFloat passwordTextFieldY = CGRectGetMaxY(usernameLayer.frame) + 30 - textFieldAdditionalHeight;
        UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(passwordTextFieldX, passwordTextFieldY, passwordTextFieldW, passwordTextFieldH)];
        passwordTextField.textColor = [UIColor colorFromHexString:LPColor7];
        passwordTextField.font = [UIFont systemFontOfSize:userNameFontSize];
        passwordTextField.placeholder = passwordPlaceHolder;
        passwordTextField.secureTextEntry = YES;
        passwordTextField.delegate = self;
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [self addSubview:passwordTextField];
        self.passwordTextField = passwordTextField;
        
        CAShapeLayer *passwordLayer = [CAShapeLayer layer];
        passwordLayer.frame = CGRectMake(passwordTextFieldX, passwordTextFieldY + passwordTextFieldH + 8, passwordTextFieldW, 0.5f);
        passwordLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
        [self.layer addSublayer:passwordLayer];
        
        // 进入奇点
        NSString *loginButtonTitle = @"进入奇点";
        CGFloat loginButtonFontSize = LPFont4;
        CGFloat loginButtonX = usernameTextFieldX;
        CGFloat loginButtonW = usernameTextFieldW;
        CGFloat loginButtonH = 44;
        CGFloat loginButtonY = CGRectGetMaxY(passwordLayer.frame) + 29;
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(loginButtonX, loginButtonY, loginButtonW, loginButtonH)];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:loginButtonFontSize];
        [loginButton setTitle:loginButtonTitle forState:UIControlStateNormal];
        [loginButton setTitleColor: [UIColor colorFromHexString:@"#ffffff"] forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor colorFromHexString:@"#0091fa"];
        loginButton.layer.cornerRadius = 3;
        loginButton.clipsToBounds = YES;
        [loginButton addTarget:self action:@selector(loginButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
        
        // 忘记密码
        NSString *forgetPassword = @"忘记密码?";
        CGFloat forgetPasswordFontSize = LPFont5;
        CGFloat forgetPasswordX = loginButtonX;
        CGFloat forgetPasswordW =  [forgetPassword sizeWithFont:[UIFont systemFontOfSize:forgetPasswordFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].width;
        CGFloat forgetPasswordH = [forgetPassword sizeWithFont:[UIFont systemFontOfSize:forgetPasswordFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height;
        CGFloat forgetPasswordY = CGRectGetMaxY(loginButton.frame) + 16;
        
        UIButton *forgetPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(forgetPasswordX, forgetPasswordY, forgetPasswordW, forgetPasswordH)];
        forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:forgetPasswordFontSize];
        [forgetPasswordButton setTitle:forgetPassword forState:UIControlStateNormal];
        [forgetPasswordButton setTitleColor: [UIColor colorFromHexString:LPColor7] forState:UIControlStateNormal];
        forgetPasswordButton.backgroundColor = [UIColor colorFromHexString:LPColor9];
        forgetPasswordButton.enlargedEdge = 10;
        [forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgetPasswordButton];
        
        // 立即注册
        NSString *registerStr = @"立即注册";
        CGFloat registerW =  [registerStr sizeWithFont:[UIFont systemFontOfSize:forgetPasswordFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].width;
        CGFloat registerX = ScreenWidth - registerW - padding;
        CGFloat registerH = forgetPasswordH;
        CGFloat registerY = forgetPasswordY;
        
        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(registerX, registerY, registerW, registerH)];
        registerButton.titleLabel.font = [UIFont systemFontOfSize:forgetPasswordFontSize];
        [registerButton setTitle:registerStr forState:UIControlStateNormal];
        [registerButton setTitleColor: [UIColor colorFromHexString:LPColor7] forState:UIControlStateNormal];
        registerButton.backgroundColor =  [UIColor colorFromHexString:LPColor9];
        registerButton.enlargedEdge = 10;
        [registerButton addTarget:self action:@selector(registerButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:registerButton];
        
        
        // 其他登录方式
        CGFloat imageViewH = 33;
        if (iPhone6Plus) {
            imageViewH = 38;
        }
        CGFloat paddingBottom = 60;
        CGFloat weixinPaddingTop = 15;
        
        NSString *otherLoginTitle = @"其他登录方式";
        CGFloat otherLoginFontSize = LPFont5;
        CGFloat otherLoginLabelW =  [otherLoginTitle sizeWithFont:[UIFont systemFontOfSize:otherLoginFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].width + 20;
        CGFloat otherLoginLabelX = (ScreenWidth - otherLoginLabelW) / 2;
        CGFloat otherLoginLabelH = [otherLoginTitle sizeWithFont:[UIFont systemFontOfSize:otherLoginFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height;
        CGFloat otherLoginLabelY = ScreenHeight - imageViewH - paddingBottom - weixinPaddingTop - otherLoginLabelH;
        
        CGFloat otherLoginSeperatorLabelX = 32;
        CGFloat otherLoginSeperatorLabelY = otherLoginLabelY + otherLoginLabelH / 2;
        CGFloat otherLoginSeperatorLabelW = ScreenWidth - otherLoginSeperatorLabelX * 2;
        
        
        CAShapeLayer *otherLoginSeperatorLayer = [CAShapeLayer layer];
        otherLoginSeperatorLayer.frame = CGRectMake(otherLoginSeperatorLabelX, otherLoginSeperatorLabelY, otherLoginSeperatorLabelW, 0.5f);
        otherLoginSeperatorLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
        [self.layer addSublayer:otherLoginSeperatorLayer];
        
        UILabel *otherLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(otherLoginLabelX, otherLoginLabelY, otherLoginLabelW, otherLoginLabelH)];
        otherLoginLabel.text = otherLoginTitle;
        otherLoginLabel.font = [UIFont systemFontOfSize:otherLoginFontSize];
        otherLoginLabel.textColor = [UIColor colorFromHexString:LPColor7];
        otherLoginLabel.backgroundColor =  [UIColor colorFromHexString:LPColor9];
        otherLoginLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:otherLoginLabel];
        
        // 微信登录 微博登录
        
        CGFloat weixinButtonX = 40;
        if (iPhone6Plus) {
            weixinButtonX = 60;
        }
        
        CGFloat weixinButtonW = imageViewH;
        CGFloat weixinButtonH = imageViewH;
        CGFloat weixinButtonY = CGRectGetMaxY(otherLoginLabel.frame) + 15;
        
        UIButton *weixinButton = [[UIButton alloc] initWithFrame:CGRectMake(weixinButtonX, weixinButtonY, weixinButtonW, weixinButtonH)];
        [weixinButton setBackgroundImage:[UIImage imageNamed:@"loginWeChat"] forState:UIControlStateNormal];
        [weixinButton addTarget:self action:@selector(weixinButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        weixinButton.enlargedEdge = 10;
        [self addSubview:weixinButton];
        
        NSString *weixinLabelTitle = @"微信登录";
        CGFloat weixinLabelPadding = 10;
        CGFloat weixinLabelFontSize = LPFont5;
        CGFloat weixinLabelX = CGRectGetMaxX(weixinButton.frame) + weixinLabelPadding;
        CGFloat weixinLabelW = [weixinLabelTitle sizeWithFont:[UIFont systemFontOfSize:weixinLabelFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].width;
        CGFloat weixinLabelH = [weixinLabelTitle sizeWithFont:[UIFont systemFontOfSize:weixinLabelFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height;
        
        UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(weixinLabelX, 0, weixinLabelW, weixinLabelH)];
        weixinLabel.userInteractionEnabled = YES;
        weixinLabel.text = weixinLabelTitle;
        weixinLabel.font = [UIFont systemFontOfSize:weixinLabelFontSize];
        weixinLabel.textColor = [UIColor colorFromHexString:LPColor7];
        weixinLabel.textAlignment = NSTextAlignmentLeft;
        weixinLabel.centerY = weixinButton.centerY;
        UITapGestureRecognizer *weixinGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weixinLabelRecognizer)];
        [weixinLabel addGestureRecognizer:weixinGestureRecognizer];
        [self addSubview:weixinLabel];
    
        
        NSString *weiboLabelTitle = @"微博登录";
        CGFloat weiboLabelFontSize = LPFont5;
        CGFloat weiboLabelW = [weiboLabelTitle sizeWithFont:[UIFont systemFontOfSize:weiboLabelFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].width;
        CGFloat weiboLabelX = ScreenWidth - weixinButtonX - weiboLabelW;
        CGFloat weiboLabelH = [weiboLabelTitle sizeWithFont:[UIFont systemFontOfSize:weiboLabelFontSize] maxSize:CGSizeMake(ScreenWidth,CGFLOAT_MAX)].height;
        
        UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(weiboLabelX, 0, weiboLabelW, weiboLabelH)];
        weiboLabel.userInteractionEnabled = YES;
        weiboLabel.text = weiboLabelTitle;
        weiboLabel.font = [UIFont systemFontOfSize:weixinLabelFontSize];
        weiboLabel.textColor = [UIColor colorFromHexString:LPColor7];
        weiboLabel.textAlignment = NSTextAlignmentLeft;
        weiboLabel.centerY = weixinButton.centerY;
        
        UITapGestureRecognizer *weiboGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiboLabelRecognizer)];
        [weiboLabel addGestureRecognizer:weiboGestureRecognizer];
        
        [self addSubview:weiboLabel];
        
        CGFloat weiboButtonW = imageViewH;
        CGFloat weiboButtonX = CGRectGetMinX(weiboLabel.frame) - weixinLabelPadding - weiboButtonW;
        CGFloat weiboButtonH = imageViewH;
        CGFloat weiboButtonY = weixinButtonY;
        
        UIButton *weiboButton = [[UIButton alloc] initWithFrame:CGRectMake(weiboButtonX, weiboButtonY, weiboButtonW, weiboButtonH)];
        [weiboButton setBackgroundImage:[UIImage imageNamed:@"loginSina"] forState:UIControlStateNormal];
        [weiboButton addTarget:self action:@selector(weiboButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        weiboButton.enlargedEdge = 10;
        [self addSubview:weiboButton];
        
        
        CGFloat seperatorLayerX = self.centerX;
        CGFloat seperatorLayerH = 12;
        CGFloat seperatorLayerW = 0.5;
        CGFloat seperatorLayerY = weixinButtonY + (weixinButtonH - seperatorLayerH) / 2;
        CAShapeLayer *seperatorLayer = [CAShapeLayer layer];
        seperatorLayer.frame = CGRectMake(seperatorLayerX, seperatorLayerY, seperatorLayerW, seperatorLayerH);
        seperatorLayer.backgroundColor = [UIColor colorFromHexString:LPColor10].CGColor;
        [self.layer addSublayer:seperatorLayer];
        
        // 添加移除键盘手势
        UITapGestureRecognizer *removeKeyboardRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
        [self addGestureRecognizer:removeKeyboardRecognizer];
    }
    return self;
}

#pragma mark - 结束编辑
- (void)removeKeyboard {
    [self endEditing:YES];
}

#pragma mark - 注册
- (void)registerButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(didRegisterWithLoginView:)]) {
        [self.delegate didRegisterWithLoginView:self];
    }
}

#pragma mark - 找回密码
- (void)forgetPasswordButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(didFindPassWordWithLoginView:)]) {
        [self.delegate didFindPassWordWithLoginView:self];
    }
}

#pragma mark - 登录
- (void)loginButtonDidClick {
    if (self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(didLoginWithLoginView:userName:password:)]) {
            [self.delegate didLoginWithLoginView:self userName:self.usernameTextField.text password:self.passwordTextField.text];
        }
    } else {
       [MBProgressHUD showError:@"请将信息填写完整"];
    }
 
}


#pragma mark - 关闭
- (void)closeButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(didCloseLoginView:)]) {
        [self.delegate didCloseLoginView:self];
    }
}

#pragma mark - 微信登录
- (void)weixinButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(didWeixinLoginWithLoginView:)]) {
        [self.delegate didWeixinLoginWithLoginView:self];
    }
}

- (void)weixinLabelRecognizer {
    if ([self.delegate respondsToSelector:@selector(didWeixinLoginWithLoginView:)]) {
        [self.delegate didWeixinLoginWithLoginView:self];
    }
}

#pragma mark - 微博登录
- (void)weiboButtonDidClick {
    if ([self.delegate respondsToSelector:@selector(didSinaLoginWithLoginView:)]) {
        [self.delegate didSinaLoginWithLoginView:self];
    }
}

- (void)weiboLabelRecognizer {
    if ([self.delegate respondsToSelector:@selector(didSinaLoginWithLoginView:)]) {
        [self.delegate didSinaLoginWithLoginView:self];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameTextField) {
        // 判断邮箱格式是否正确
        BOOL emailFormat = [LPValidateTool validateEmail:self.usernameTextField.text];
        if (emailFormat) {
            [self.usernameTextField resignFirstResponder];
            [self.passwordTextField becomeFirstResponder];
        } else {
            [MBProgressHUD showError:@"邮箱格式不正确"];
        }
        
    } else if (textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
    } else {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}



@end
