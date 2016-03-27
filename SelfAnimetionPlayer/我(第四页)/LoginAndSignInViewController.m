//
//  LoginAndSignInViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/25.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "LoginAndSignInViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LoginAndSignInViewController () //<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//声明用户名和密码的文本框
@property (nonatomic, strong) UITextField *accountTextView;
@property (nonatomic, strong) UITextField *pasWordTextView;
//声明注册时的账号 ，密码，确认密码文本框
@property (nonatomic, strong) UITextField *setAccountTextView;
@property (nonatomic, strong) UITextField *setPasWordTextView;
@property (nonatomic, strong) UITextField *surePasWordTextView;
//昵称
@property (nonatomic, strong) UITextField *setNicoNameTextView;
//头像
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation LoginAndSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载控件
    if (!_LogOrSign) {
        [self loadLoginControls];
    } else {
        [self loadSignInControls];
    }
    
}
//注册用控件
- (void)loadSignInControls {
    
    _headImageView = [[UIImageView alloc] init];
    _headImageView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 0.3);
    _headImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) / 2.5);
    _headImageView.backgroundColor = [UIColor lightGrayColor];
    _headImageView.image = [UIImage imageNamed:@"logo"];
    _headImageView.userInteractionEnabled = YES;
    [self.view addSubview:_headImageView];
    
    //背景框
    UILabel *bgLabelForATV = [[UILabel alloc] init];
    bgLabelForATV.bounds = CGRectMake(0, 0, 300, 35);
    bgLabelForATV.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 80);
    bgLabelForATV.layer.cornerRadius = 8;
    bgLabelForATV.layer.borderWidth = 1;
    bgLabelForATV.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    [self.view addSubview:bgLabelForATV];
    UILabel *bgLabelForPTV = [[UILabel alloc] init];
    bgLabelForPTV.bounds = CGRectMake(0, 0, 300, 35);
    bgLabelForPTV.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    bgLabelForPTV.layer.cornerRadius = 8;
    bgLabelForPTV.layer.borderWidth = 1;
    bgLabelForPTV.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    [self.view addSubview:bgLabelForPTV];
    UILabel *bgLabelForSPTV = [[UILabel alloc] init];
    bgLabelForSPTV.bounds = CGRectMake(0, 0, 300, 35);
    bgLabelForSPTV.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + 80);
    bgLabelForSPTV.layer.cornerRadius = 8;
    bgLabelForSPTV.layer.borderWidth = 1;
    bgLabelForSPTV.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    [self.view addSubview:bgLabelForSPTV];
    UILabel *bgLabelForNicN = [[UILabel alloc] init];
    bgLabelForNicN.bounds = CGRectMake(0, 0, 300, 35);
    bgLabelForNicN.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + 160);
    bgLabelForNicN.layer.cornerRadius = 8;
    bgLabelForNicN.layer.borderWidth = 1;
    bgLabelForNicN.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    [self.view addSubview:bgLabelForNicN];
    //账号文本框
    _setAccountTextView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 140, CGRectGetMidY(self.view.bounds) - 100, 290, 40)];
    _setAccountTextView.placeholder = @"设置账号";
    _setAccountTextView.font = [UIFont systemFontOfSize:17];
    _setAccountTextView.clearButtonMode = YES;
    [self.view addSubview:_setAccountTextView];
    //密码文本框
    _setPasWordTextView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 140, CGRectGetMidY(self.view.bounds) - 20, 290, 40)];
    [_setPasWordTextView setSecureTextEntry:YES];
    _setPasWordTextView.placeholder = @"设置密码";
    _setPasWordTextView.clearButtonMode = YES;
    [self.view addSubview:_setPasWordTextView];
    //确认密码文本框
    _surePasWordTextView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 140, CGRectGetMidY(self.view.bounds) + 60, 290, 40)];
    [_surePasWordTextView setSecureTextEntry:YES];
    _surePasWordTextView.placeholder = @"确认密码";
    _surePasWordTextView.clearButtonMode = YES;
    [self.view addSubview:_surePasWordTextView];
    //设置昵称文本框
    _setNicoNameTextView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 140, CGRectGetMidY(self.view.bounds) + 140, 290, 40)];
    _setNicoNameTextView.placeholder = @"设置昵称";
    _setNicoNameTextView.clearButtonMode = YES;
    [self.view addSubview:_setNicoNameTextView];
    
    UILabel *labelForCont = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(bgLabelForATV.frame) - 30, 100, 20)];
    labelForCont.text = @"设置账号:";
    labelForCont.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    labelForCont.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labelForCont];
    UILabel *labelForPasW = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(bgLabelForPTV.frame) - 30, 100, 20)];
    labelForPasW.text = @"设置密码:";
    labelForPasW.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    labelForPasW.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labelForPasW];
    UILabel *labelForSurP = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(bgLabelForSPTV.frame) - 30, 100, 20)];
    labelForSurP.text = @"确认密码:";
    labelForSurP.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    labelForSurP.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labelForSurP];
    UILabel *labelForNicN = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(bgLabelForNicN.frame) - 30, 100, 20)];
    labelForNicN.text = @"设置昵称:";
    labelForNicN.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    labelForNicN.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labelForNicN];
    //确认注册按钮
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeSystem];
    signInButton.bounds = CGRectMake(0, 0, 120, 40);
    signInButton.center = CGPointMake(CGRectGetMidX(self.view.bounds) - 80, CGRectGetMidY(self.view.bounds) + 220);
    signInButton.layer.cornerRadius = 8;
    [signInButton setTitle:@"注册" forState:UIControlStateNormal];
    signInButton.titleLabel.font = [UIFont systemFontOfSize:17];
    signInButton.tintColor = [UIColor whiteColor];
    signInButton.tag = 1002;
    signInButton.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    [signInButton addTarget:self action:@selector(loginTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInButton];
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.bounds = CGRectMake(0, 0, 120, 40);
    cancelButton.center = CGPointMake(CGRectGetMidX(self.view.bounds) + 80, CGRectGetMidY(self.view.bounds) + 220);
    cancelButton.layer.cornerRadius = 8;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelButton.tintColor = [UIColor whiteColor];
    cancelButton.tag = 1000;
    cancelButton.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    [cancelButton addTarget:self action:@selector(loginTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

//加载登录用控件
- (void)loadLoginControls {
    _headImageView = [[UIImageView alloc] init];
    _headImageView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds) * 0.3);
    _headImageView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) / 2);
    _headImageView.backgroundColor = [UIColor lightGrayColor];
    _headImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_headImageView];
    //背景框
    UILabel *bgLabelForATV = [[UILabel alloc] init];
    bgLabelForATV.bounds = CGRectMake(0, 0, 300, 35);
    bgLabelForATV.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 60);
    bgLabelForATV.layer.cornerRadius = 8;
    bgLabelForATV.layer.borderWidth = 1;
    bgLabelForATV.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    [self.view addSubview:bgLabelForATV];
    UILabel *bgLabelForPTV = [[UILabel alloc] init];
    bgLabelForPTV.bounds = CGRectMake(0, 0, 300, 35);
    bgLabelForPTV.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    bgLabelForPTV.layer.cornerRadius = 8;
    bgLabelForPTV.layer.borderWidth = 1;
    bgLabelForPTV.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    [self.view addSubview:bgLabelForPTV];
    //账号文本框
    _accountTextView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 140, CGRectGetMidY(self.view.bounds) - 80, 290, 40)];
    _accountTextView.placeholder = @"请输入账号";
    _accountTextView.font = [UIFont systemFontOfSize:17];
    _accountTextView.clearButtonMode = YES;
    [self.view addSubview:_accountTextView];
    //密码文本框
    _pasWordTextView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 140, CGRectGetMidY(self.view.bounds) - 20, 290, 40)];
    [_pasWordTextView setSecureTextEntry:YES];
    _pasWordTextView.placeholder = @"请输入密码";
    _pasWordTextView.clearButtonMode = YES;
    [self.view addSubview:_pasWordTextView];
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.bounds = CGRectMake(0, 0, 120, 40);
    loginButton.center = CGPointMake(CGRectGetMidX(self.view.bounds) - 80, CGRectGetMidY(self.view.bounds) + 70);
    loginButton.layer.cornerRadius = 8;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    loginButton.tintColor = [UIColor whiteColor];
    loginButton.tag = 1001;
    loginButton.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    [loginButton addTarget:self action:@selector(loginTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.bounds = CGRectMake(0, 0, 120, 40);
    cancelButton.center = CGPointMake(CGRectGetMidX(self.view.bounds) + 80, CGRectGetMidY(self.view.bounds) + 70);
    cancelButton.layer.cornerRadius = 8;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    cancelButton.tintColor = [UIColor whiteColor];
    cancelButton.tag = 1000;
    cancelButton.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    [cancelButton addTarget:self action:@selector(loginTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

- (void)loginTaped:(UIButton *)sender {
    switch (sender.tag - 1000) {
        case 0:{
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        case 1:{
            [self loginButton];
            
        }
            break;
        case 2:{
            [self sureSignInMassage];
        }
            break;
        default:
            break;
    }
    
}

//注册按钮
- (void)sureSignInMassage {
    if ([_setAccountTextView.text isEqual: @""] || [_setPasWordTextView.text isEqual:@""]|| [_surePasWordTextView.text isEqual:@""] || [_setNicoNameTextView.text isEqual:@""]) {
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"请完善注册信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertControler addAction:cancelAction];
        [self presentViewController:alertControler animated:YES completion:nil];
    } else if(_setPasWordTextView.text != _surePasWordTextView.text) {
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"两次密码输入不一致" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertControler addAction:cancelAction];
        [self presentViewController:alertControler animated:YES completion:nil];
    } else {
        
        AVUser *user = [AVUser user];
        user.username = _setAccountTextView.text;
        user.password = _setPasWordTextView.text;
        [user setObject:_setNicoNameTextView.text forKey:@"niconame"];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"注册成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertControler addAction:sureAction];
                [self presentViewController:alertControler animated:YES completion:nil];
            } else {
                UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"该账号已存在" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertControler addAction:sureAction];
                [self presentViewController:alertControler animated:YES completion:nil];
                NSLog(@"%@",error.localizedDescription);
            }
        }];
        
        
        
    }
}
//登录按钮
- (void)loginButton {
    [AVUser logInWithUsernameInBackground:_accountTextView.text password:_pasWordTextView.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            //            NSLog(@"%@,%@",user.username,user.email);
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:_accountTextView.text forKey:@"account"]; //账号
            [dic setObject:[user objectForKey:@"niconame"] forKey:@"niconame"];//昵称
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:_accountTextView.text];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //userdefaults
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didLogin"];
            //同步到沙盒
            [[NSUserDefaults standardUserDefaults] synchronize];
            //userdefaults将已登录的账号存到
            [[NSUserDefaults standardUserDefaults] setObject:_accountTextView.text forKey:@"didLoginAccount"];
            //同步到沙盒
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AVQuery *query = [AVQuery queryWithClassName:@"CollectionForAccont"];
            AVObject *post = [query getObjectWithId:@"56a85854a633bd02579ac3c2"];
            NSString *strKeyNew = [NSString stringWithFormat:@"coll%@",_accountTextView.text];
            if (![post objectForKey:strKeyNew]) {
                NSLog(@"开辟收藏空间");
                [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [post setObject:[NSDictionary dictionary] forKey:strKeyNew];
                    [post saveInBackground];
                }];
            }
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            if ([_accountTextView.text isEqualToString:@""] || [_pasWordTextView.text isEqualToString:@""]) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入账号或密码" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                //推出alertcontroller
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"账号或密码错误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                _pasWordTextView.text = @"";
                //推出alertcontroller
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }
    }];
    
    
}

//回收键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_accountTextView resignFirstResponder];
    [_pasWordTextView resignFirstResponder];
    [_setAccountTextView resignFirstResponder];
    [_setPasWordTextView resignFirstResponder];
    [_surePasWordTextView resignFirstResponder];
    [_setNicoNameTextView resignFirstResponder];
    
}
@end
