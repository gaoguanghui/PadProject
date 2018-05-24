//
//  LoginViewController.m
//  PadProject
//
//  Created by SansiMac on 2018/5/17.
//  Copyright © 2018年 SansiMac. All rights reserved.
//

#import "LoginViewController.h"
#import "SplitViewController.h"
#import "LoginTextFieldView.h"
#import "LoginButtonView.h"
#import "LoginViewModel.h"

#import "LoginAnimationView.h"
#import "ProgressView.h"


static const CGFloat kSpacing = 20;
static const CGFloat kHeadW = 80;
static const CGFloat kViewHeight = 40;
static const CGFloat kViewWidth = 260;

@interface LoginViewController ()<LoginButtonViewDelegate>
@property (nonatomic,strong) UIImageView *headImgView;
@property (strong, nonatomic) LoginTextFieldView *userNameView;
@property (strong, nonatomic) LoginTextFieldView *passwordView;
@property (strong, nonatomic) LoginButtonView *loginButton;
@property (strong, nonatomic) UILabel *maskLabel;
@property (nonatomic,strong) LoginViewModel *loginViewModel;

@property (nonatomic,strong) LoginAnimationView *animationView;

@property (nonatomic,strong) ProgressView *progressView;
@end

@implementation LoginViewController
- (LoginViewModel *)loginViewModel {
    _loginViewModel = [[LoginViewModel alloc] init];
    _loginViewModel.userName = self.userNameView.textField.text;
    _loginViewModel.password = self.passwordView.textField.text;
    return _loginViewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    [self loginEnabledProving];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)initWithView{
    WEAKSELF
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_headImgView) {
        _headImgView = ({
            UIImageView * headImgView = [[UIImageView alloc] init];
            headImgView.backgroundColor = kRandomColor;
            headImgView.layer.cornerRadius = kHeadW/2;
            headImgView.layer.masksToBounds = YES;
            [self.view addSubview:headImgView];
            headImgView;
        });
    }
    
    if (!_userNameView) {
        _userNameView = ({
            LoginTextFieldView *textFieldView = [[LoginTextFieldView alloc] initWithFrame:CGRectZero];
            textFieldView.placeholder = @"用户名";
            textFieldView.textField.clearButtonMode = UITextFieldViewModeAlways;
            [self.view addSubview:textFieldView];
            textFieldView;
        });
    }
    
    if (!_passwordView) {
        _passwordView = ({
            LoginTextFieldView *textFieldView = [[LoginTextFieldView alloc] initWithFrame:CGRectZero];
            textFieldView.placeholder = @"密码";
            textFieldView.textField.secureTextEntry = YES;
            textFieldView.textField.clearButtonMode = UITextFieldViewModeAlways;
            [self.view addSubview:textFieldView];
            textFieldView;
        });
    }
    
    if (!_loginButton) {
        _loginButton = ({
            LoginButtonView *buttonView = [[LoginButtonView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)];
            buttonView.delegate = self;
            [self.view addSubview:buttonView];
            buttonView.finishBlock = ^() {
                [weakSelf loginAction];
            };
            buttonView;
        });
    }
    if (!_maskLabel) {
        _maskLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = kButtonTitle;
            label.font = kButtonTitleFontSize;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor lightGrayColor];
            label.backgroundColor = [UIColor whiteColor];
            label.layer.cornerRadius = 20;
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            label.layer.borderWidth = 2.f;
            label.clipsToBounds = YES;
            [self.view addSubview:label];
            label;
        });
    }
    
    if (!_animationView) {
        _animationView = ({
            LoginAnimationView * animationView = [[LoginAnimationView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)];
            animationView.backgroundColor = [UIColor purpleColor];
            [self.view addSubview:animationView];
            animationView;
        });
    }
    
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(kViewWidth, kViewHeight));
    }];
    [_animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.loginButton.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(kViewWidth, kViewHeight));
    }];
    [_maskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.loginButton);
    }];
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kViewWidth, kViewHeight));
        make.centerX.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.loginButton.mas_top).offset(-50);
    }];
    [_userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kViewWidth, kViewHeight));
        make.centerX.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.passwordView.mas_top).offset(-kSpacing);
    }];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kHeadW, kHeadW));
        make.centerX.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.userNameView.mas_top).offset(-kSpacing);
    }];
    
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, 50, 50);
    shapeLayer.backgroundColor = [UIColor blackColor].CGColor;
    shapeLayer.fillColor = [UIColor blackColor].CGColor;
    shapeLayer.strokeColor = [UIColor cyanColor].CGColor;
//    shapeLayer.lineWidth = 5;
    [self.view.layer addSublayer:shapeLayer];
    
    //绘制自带圆角的路径
//    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 50, 50) cornerRadius:10];
    //绘制矩形
//    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 50, 50)];
    //绘制圆形
//    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(40, 40, 20, 20)];
    //绘制矩形指定一个角加圆角
//    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 0, 40, 60) byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 20)];
//    shapeLayer.path = bezierPath.CGPath;
    /*
    //添加一个圆的路径  路径动画 各种keyPath下的动画，
//    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    shapeLayer.anchorPoint = CGPointMake(0, 0);
//    [bezierPath addArcWithCenter:CGPointMake(0, 0) radius:50 startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 50, 50)];
    shapeLayer.path = bezierPath.CGPath;
    
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    basicAnimation.fromValue = @(0);
//    basicAnimation.toValue = @(1);
//    basicAnimation.duration = 3;
//    basicAnimation.removedOnCompletion = NO;
//    basicAnimation.fillMode = kCAFillModeForwards;
//
//    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    basicAnimation1.fromValue = @(1);
//    basicAnimation1.toValue = @(0);
//    basicAnimation1.beginTime = 3;
//    basicAnimation1.duration = 6;
//    basicAnimation1.removedOnCompletion = NO;
//    basicAnimation1.fillMode = kCAFillModeForwards;
//
//    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
//    animationGroup.duration = basicAnimation1.beginTime+basicAnimation1.duration;
//    animationGroup.fillMode = kCAFillModeForwards;
//    animationGroup.removedOnCompletion = NO;
//    animationGroup.animations = @[basicAnimation, basicAnimation1];
//    [shapeLayer addAnimation:animationGroup forKey:@"animation"];
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI*2);
    basicAnimation.duration = 3;
    basicAnimation.repeatCount = LONG_MAX;
    basicAnimation.removedOnCompletion = NO;
    [shapeLayer addAnimation:basicAnimation forKey:@"loadingAnimation"];
*/
    
    
    /*view.layer.mask应用  提供mask遮罩
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    btn.frame = CGRectMake(100, 80, 100, 40);
    [self.view addSubview:btn];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.backgroundColor = [UIColor redColor].CGColor;
    maskLayer.fillColor = [UIColor brownColor].CGColor;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(5, 0)];
    [path addLineToPoint:CGPointMake(100-5, 0)];
    [path addQuadCurveToPoint:CGPointMake(100, 5) controlPoint:CGPointMake(100, 0)];
    [path addLineToPoint:CGPointMake(100, 40-5)];
    [path addQuadCurveToPoint:CGPointMake(100-5, 40) controlPoint:CGPointMake(100, 40)];
    [path addLineToPoint:CGPointMake(5, 40)];
    [path addQuadCurveToPoint:CGPointMake(0, 40-5) controlPoint:CGPointMake(0, 40)];
    [path addLineToPoint:CGPointMake(0, 5)];
    [path addQuadCurveToPoint:CGPointMake(5, 0) controlPoint:CGPointMake(0, 0)];
    [path closePath];
    maskLayer.path = path.CGPath;
    btn.layer.mask = maskLayer;
     */
    
    _progressView = [[ProgressView alloc] initWithFrame:CGRectMake(50, 100, 50, 50)];
    _progressView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_progressView];
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

}
- (void)timerAction{
    if (_progressView.progress < 1) {
        _progressView.progress += 0.02;
    }else{
        _progressView.progress = 0.0;
    }
    [_progressView setNeedsDisplay];
}
#pragma 登录按钮可操作验证
- (void)loginEnabledProving{
    WEAKSELF
    RACSignal * validUsernameSignal = [_userNameView.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([weakSelf verifyUsername:value]);
    }];
    RACSignal * validPasswordSignal = [_passwordView.textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([weakSelf verifyPasswordString:value]);
    }];
    RAC(_loginButton.button, enabled) = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id (NSNumber * usernameValid, NSNumber * passwordValid){
        BOOL isValid = [usernameValid boolValue] && [passwordValid boolValue];
        return @(isValid);
    }];
    RAC(_maskLabel, hidden) = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal] reduce:^id (NSNumber * usernameValid, NSNumber * passwordValid){
        BOOL isValid = [usernameValid boolValue] && [passwordValid boolValue];
        return @(isValid);
    }];
}
#pragma mark -- 验证用户名
- (BOOL)verifyUsername:(NSString *)string{
    //
    //在做些判断 给用户一些输入错误下的UI提示
    //
    NSString *userNameRegex = @"^[A-Za-z0-9]{4,16}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:string];
}
#pragma 验证密码
- (BOOL)verifyPasswordString:(NSString *)string{
    NSString *userPasswordRegex = @"^[A-Za-z0-9]{6,16}+$";
    NSPredicate *userPasswordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userPasswordRegex];
    return [userPasswordPredicate evaluateWithObject:string];
}
#pragma mark - LoginButtonViewDelegate
- (void)loginButtonViewActivated {
    [self.view endEditing:YES];
    self.view.userInteractionEnabled = NO;
}
#pragma mark -- 登录
- (void)loginAction{
    @weakify(self)
    [self.loginViewModel.loginSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:UIApplication.sharedApplication.keyWindow animated:YES];
            SplitViewController  * vc = [[SplitViewController alloc] init];
            UIApplication.sharedApplication.keyWindow.rootViewController = vc;
        });
    }];
}
//- (void)loginButtonClick {
////    WEAKSELF
////    [self.loginViewModel.requestSignal subscribeNext:^(id x) {
////        if ([x isKindOfClass:[UserInfo class]]) {
////            UserInfo *user =  (UserInfo *)x;
////            weakSelf.loginSuccessBlock(user);
////            appDelegate.isLogged = YES;
////            appDelegate.userInfo = user;
////            [_loginButton removeAllAnimation];
////            [weakSelf.navigationController popViewControllerAnimated:YES];
////        } else {
////            [_loginButton restoreSubViews];
////            NSError *error = (NSError *)x;
////            NSString *errorMsg = error.localizedDescription;
////            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
////            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                weakSelf.view.userInteractionEnabled = YES;
////                weakSelf.navigationController.navigationBar.userInteractionEnabled = YES;
////            }];
////            [alertController addAction:defaultAction];
////            [weakSelf presentViewController:alertController animated:YES completion:nil];
////        }
////    }];
//}

#pragma mark -- keyboard show/hide action
- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * someValue = (NSValue *)[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [someValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    CGFloat offPad = kScreenHeight-CGRectGetMaxY(_loginButton.frame);
    CGFloat value = keyboardH - offPad;
    if (value > 0) {
        WEAKSELF
        [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf.view);
            make.centerY.mas_equalTo(weakSelf.view).offset(-value-20);
            make.size.mas_equalTo(CGSizeMake(kViewWidth, kViewHeight));
        }];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    WEAKSELF
    [_loginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.centerY.mas_equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(kViewWidth, kViewHeight));
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
//////////////////////////////////////////
/*
- (void)setupViews{
    [self.view addSubview:self.headImgView];
    [self.view addSubview:self.accountTF];
    [self.view addSubview:self.accountLab];
    [self.view addSubview:self.pswTF];
    [self.view addSubview:self.pswLab];
    [self.view addSubview:self.loginBtn];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [_pswTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.loginBtn.mas_top).offset(-20);
    }];
    [_accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.pswTF.mas_top).offset(-20);
    }];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.accountTF.mas_top).offset(-20);
    }];
    [_accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.accountTF);
    }];
    [_pswLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pswTF);
    }];
    
    RAC(_loginBtn, enabled) = [[RACSignal combineLatest:@[_accountTF.rac_textSignal, _pswTF.rac_textSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return @([value[0] length] > 3 && [value[1] length] > 6);
    }];
    @weakify(self)
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:UIApplication.sharedApplication.keyWindow animated:YES];
            [self login];
        });
    }];
}

#pragma mark -- keyboard show/hide action
- (void)keyboardWillShow:(NSNotification *)notification{
    NSValue * someValue = (NSValue *)[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [someValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    CGFloat offPad = kScreenHeight-CGRectGetMaxY(_loginBtn.frame);
    CGFloat value = keyboardH - offPad;
    if (value > 0) {
        [_loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.centerY.mas_equalTo(self.view).offset(-value-20);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
    }
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    [_loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark -- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _accountTF) {
        CGSize size = _accountLab.bounds.size;
        [_accountLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
            make.centerY.mas_equalTo(self.accountTF);
            make.right.mas_equalTo(self.accountTF.mas_left).offset(-5);
        }];
        [UIView animateWithDuration:0.15 animations:^{
            [self.view layoutIfNeeded];
        }];
    }else{
        CGSize size = _pswLab.bounds.size;
        [_pswLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
            make.centerY.mas_equalTo(self.pswTF);
            make.right.mas_equalTo(self.pswTF.mas_left).offset(-5);
        }];
        [UIView animateWithDuration:0.15 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
}

#pragma mark -- lazyloadViews
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.backgroundColor = kRandomColor;
        _headImgView.layer.cornerRadius = 80/2;
        _headImgView.layer.masksToBounds = YES;
    }
    return _headImgView;
}
- (UITextField *)accountTF{
    if (!_accountTF) {
        _accountTF = [[UITextField alloc] init];
        _accountTF.backgroundColor = kRandomColor;
        _accountTF.layer.cornerRadius = 5;
        _accountTF.layer.masksToBounds = YES;
        _accountTF.delegate = self;
    }
    return _accountTF;
}
- (UITextField *)pswTF{
    if (!_pswTF) {
        _pswTF = [[UITextField alloc] init];
        _pswTF.backgroundColor = kRandomColor;
        _pswTF.layer.cornerRadius = 5;
        _pswTF.layer.masksToBounds = YES;
        _pswTF.delegate = self;
    }
    return _pswTF;
}
- (UILabel *)accountLab{
    if (!_accountLab) {
        _accountLab = [[UILabel alloc] init];
        _accountLab.text = @"账号";
        _accountLab.textColor = [UIColor blueColor];
        [_accountLab sizeToFit];
    }
    return _accountLab;
}
- (UILabel *)pswLab{
    if (!_pswLab) {
        _pswLab = [[UILabel alloc] init];
        _pswLab.text = @"密码";
        _pswLab.textColor = [UIColor blueColor];
        [_pswTF sizeToFit];
    }
    return _pswLab;
}
- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.enabled = NO;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor orangeColor];
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}
- (void)login{
    SplitViewController  * vc = [[SplitViewController alloc] init];
    UIApplication.sharedApplication.keyWindow.rootViewController = vc;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [_animationView touch];
}
- (void)dealloc{
    debugMethod();
}
@end
