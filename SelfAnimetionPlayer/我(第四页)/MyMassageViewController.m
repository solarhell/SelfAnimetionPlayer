//
//  MyMassageViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/16.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "MyMassageViewController.h"
#import "LoginAndSignInViewController.h"
#import "CollectionVideosViewController.h"
#import <AVOSCloud/AVOSCloud.h>

#define SCREEN_WIDTH CGRectGetWidth(self.view.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(self.view.bounds)

@interface MyMassageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//登录标志
@property (nonatomic, assign) BOOL didLogin;
//我的信息
@property (nonatomic, strong) UILabel *myMassage;
//声明一个label全屏添加到 “我的信息” 用来显示我的信息详情
@property (nonatomic, strong) UILabel *detailMassage;
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
//id
@property (nonatomic, strong) UILabel *idLabel;

//注销按钮
@property (nonatomic, strong) UIButton *LogoutBtn;

@end

@implementation MyMassageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的账号";
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"iconfont-me"] tag:200];
        self.tabBarItem = item;
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"iconfont-me_selected"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BOOL didLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"];
    if (didLogin) {
        [self loadMyMassage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题颜色,字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:[ NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:20.0],NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //导航栏前景色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //自定义导航栏 背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    //隐藏返回按钮标题
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //加载视图控件
    [self loadViewControls];
}
//
- (void)loadViewControls {
    _myMassage = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, SCREEN_WIDTH - 20, SCREEN_HEIGHT / 6)];
    _myMassage.backgroundColor = [UIColor whiteColor];
    _myMassage.layer.cornerRadius = 10;
    _myMassage.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _myMassage.layer.borderWidth = 1;
    _myMassage.clipsToBounds = YES;
    [self.view addSubview:_myMassage];
    [self loadLoginMassage];
    
    UILabel *appMassage = [[UILabel alloc] initWithFrame:CGRectMake(10,SCREEN_HEIGHT - 49 - SCREEN_HEIGHT / 6 - 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT / 6)];
    appMassage.numberOfLines = 0;
    appMassage.backgroundColor = [UIColor whiteColor];
    appMassage.layer.cornerRadius = 10;
    appMassage.clipsToBounds = YES;
    appMassage.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    appMassage.layer.borderWidth = 1;
    appMassage.font = [UIFont systemFontOfSize:14];
    appMassage.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    appMassage.textAlignment = NSTextAlignmentCenter;
    appMassage.text = @"产品信息\n版本:1.1.32\nTips:\n登录后将会同步您在其他设备上的收藏信息";
    [self.view addSubview:appMassage];
    
    NSArray *array = @[@"视频收藏",@"专题收藏"];
    for (NSInteger index = 0; index < 2; index ++) {
        UIButton *collectionBut = [[UIButton alloc] initWithFrame:CGRectMake(30 + index * ((SCREEN_WIDTH - 30) * 4 / 9 + 10), 70 + SCREEN_HEIGHT / 5 + 20, (SCREEN_WIDTH - 30) * 4 / 9, (SCREEN_WIDTH - 30) * 4 / 9)];
        collectionBut.layer.cornerRadius = 10;
        collectionBut.clipsToBounds = YES;
        collectionBut.tag = 960 + index;
        collectionBut.backgroundColor = [UIColor colorWithRed:0.278 green:0.7029 blue:0.3321 alpha:0.85];
        [collectionBut addTarget:self action:@selector(buttonType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, (SCREEN_WIDTH - 30) * 4 / 9 - 20, (SCREEN_WIDTH - 30) * 4 / 9 - 20)];
        image.image = [UIImage imageNamed:array[index]];
        [collectionBut addSubview:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (SCREEN_WIDTH - 30) / 3, (SCREEN_WIDTH - 30) * 4 / 9 - 20, (SCREEN_WIDTH - 30) / 12)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[index];
        [collectionBut addSubview:label];
        [self.view addSubview:collectionBut];
    }
}
//判断是否登录 给label添加不同的view
- (void)loadLoginMassage {
    UIButton *LoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    LoginBtn.frame = CGRectMake((SCREEN_WIDTH - 20) / 2 - 50 - 20,  SCREEN_HEIGHT / 6 / 2 - 15 + 74, 50, 30);
    LoginBtn.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    LoginBtn.layer.cornerRadius = 8;
    [LoginBtn setTintColor:[UIColor whiteColor]];
    [LoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [LoginBtn addTarget:self action:@selector(loginBtnTyped:) forControlEvents:UIControlEventTouchUpInside];
    LoginBtn.clipsToBounds = YES;
    [self.view addSubview:LoginBtn];
    
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    signInBtn.frame = CGRectMake((SCREEN_WIDTH - 20) / 2 + 40,  SCREEN_HEIGHT / 6 / 2 - 15 + 74, 50, 30);
    signInBtn.layer.cornerRadius = 8;
    signInBtn.clipsToBounds = YES;
    [signInBtn setTitle:@"注册" forState:UIControlStateNormal];
    [signInBtn setTintColor:[UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0]];
    signInBtn.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    signInBtn.layer.borderWidth = 1;
    [signInBtn addTarget:self action:@selector(signInBtnTyped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    
    //    初始化我的信息详情label _detailMassage
    _detailMassage = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 0, 0)];
    _detailMassage.backgroundColor = [UIColor whiteColor];
    _detailMassage.layer.cornerRadius = 10;
    _detailMassage.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _detailMassage.layer.borderWidth = 1;
    _detailMassage.clipsToBounds = YES;
    [self.view addSubview:_detailMassage];
    //注销
    _LogoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _LogoutBtn.frame = CGRectMake((SCREEN_WIDTH - 20) / 2 + 40,  SCREEN_HEIGHT / 5 / 2 - 15 + 74, 0, 0);
    _LogoutBtn.layer.cornerRadius = 8;
    _LogoutBtn.clipsToBounds = YES;
    [_LogoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [_LogoutBtn setTintColor:[UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0]];
    _LogoutBtn.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _LogoutBtn.layer.borderWidth = 1;
    [_LogoutBtn addTarget:self action:@selector(LogoutBtnTyped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_LogoutBtn];
    //初始化头像
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, SCREEN_HEIGHT / 5 - 40, SCREEN_HEIGHT / 5 - 40)];
    _headImageView.backgroundColor = [UIColor lightGrayColor];
    _headImageView.userInteractionEnabled = YES;
    _detailMassage.userInteractionEnabled = YES;
    
    NSData *data = [[AVUser currentUser] objectForKey:@"headimage"];
    _headImageView.image = [UIImage imageWithData:data];
    
    [_detailMassage addSubview:_headImageView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChangeImage:)];
    //为控件添加手势控制器
    [_headImageView addGestureRecognizer:tapGes];
    //初始化显示昵称的label
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 20 + SCREEN_HEIGHT / 5 - 40, 20, SCREEN_HEIGHT / 4, 25)];
    _nicknameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    _nicknameLabel.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    [_detailMassage addSubview:_nicknameLabel];
    //初始化显示id的label
    _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 20 + SCREEN_HEIGHT / 5 - 40, 20 + 25 + 10, SCREEN_HEIGHT / 5, 20)];
    _idLabel.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    [_detailMassage addSubview:_idLabel];
    
    //    如果已经登录过了 则载入
    BOOL didLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"];
    if (didLogin) {
        [self loadMyMassage];
    }
}
//载入已登录的信息
- (void)loadMyMassage {
    NSString *keystr = [[NSUserDefaults standardUserDefaults] objectForKey:@"didLoginAccount"];
    if (keystr) {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:keystr];
        _nicknameLabel.text = dic[@"niconame"];
        _idLabel.text = [NSString stringWithFormat:@"id:%@", dic[@"account"]];
    }
    NSData *data = [[AVUser currentUser] objectForKey:@"headimage"];
    _headImageView.image = [UIImage imageWithData:data];
    _detailMassage.frame = CGRectMake(10, 74, SCREEN_WIDTH - 20, SCREEN_HEIGHT / 5);
    _LogoutBtn.frame = CGRectMake(SCREEN_WIDTH - 80,  SCREEN_HEIGHT / 4, 50, 30);
}
//注销按钮
- (void)LogoutBtnTyped:(UIButton *)sender {
    NSLog(@"注销");
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"确定注销？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _detailMassage.frame = CGRectMake(10, 74, 0, 0);
        _LogoutBtn.frame = CGRectMake((SCREEN_WIDTH - 20) / 2 + 40,  SCREEN_HEIGHT / 5 / 2 - 15 + 74, 0, 0);
        //userdefaults
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"didLogin"];
        //同步到沙盒
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alterController addAction:sure];
    [alterController addAction:cancelItem];
    [self presentViewController:alterController animated:YES completion:nil];
}
//登录注册按钮
- (void)loginBtnTyped:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        return;
    }
    NSLog(@"登录");
    LoginAndSignInViewController *loginOrSigninVC = [[LoginAndSignInViewController alloc] init];
    loginOrSigninVC.LogOrSign = 0;
    [self presentViewController:loginOrSigninVC animated:YES completion:nil];
    
}
- (void)signInBtnTyped:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        return;
    }
    NSLog(@"注册");
    LoginAndSignInViewController *loginOrSigninVC = [[LoginAndSignInViewController alloc] init];
    loginOrSigninVC.LogOrSign = 1;
    [self presentViewController:loginOrSigninVC animated:YES completion:nil];
}

//
- (void)buttonType:(UIButton *)sender {
    if (sender.tag - 960 == 0) {
        NSLog(@"视屏");
        //        NSMutableArray *arrForKeys = [[[NSUserDefaults standardUserDefaults] objectForKey:@"all_avnumber"] mutableCopy];
        //        NSLog(@"%@",arrForKeys);
        CollectionVideosViewController *detailVC = [[CollectionVideosViewController alloc] init];
        //        detailVC.contenst = arrForKeys;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        NSLog(@"专题");
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"暂未开放" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alterController addAction:cancelItem];
        [self presentViewController:alterController animated:YES completion:nil];
    }
}

//单击手势
- (void)tapChangeImage:(UITapGestureRecognizer *)gesture {
    NSLog(@"选择头像");
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //防止循环引用
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf selectAlbum];
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf takePhoto];
    }];
    
    [alertControler addAction:cancelAction];
    [alertControler addAction:albumAction];
    [alertControler addAction:takePhotoAction];
    [self presentViewController:alertControler animated:YES completion:nil];
}
//相册选择照片
- (void)selectAlbum {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //设置picker资源类型
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //过渡类型
    //    imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //是否需要编辑框
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//拍照
- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"你的设备不支持拍照");
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    //设置picker资源类型
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //过渡类型
    //    imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //是否需要编辑框
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info);
    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"];
    _headImageView.image = selectedImage;
    //上传头像到云端
    NSData *data = UIImageJPEGRepresentation(selectedImage, 1.0);
    [[AVUser currentUser] setObject:data forKey:@"headimage"];
    [[AVUser currentUser] save];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end



























//