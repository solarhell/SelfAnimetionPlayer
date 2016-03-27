//
//  VedioPlayViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/17.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "VedioPlayViewController.h"
#import "CustomCollectionViewCell.h"
#import "NetRequest.h"
#import <AVOSCloud/AVOSCloud.h>
@import AVFoundation;
@import AVKit;
@import SafariServices;

#define URL_OF_VEDIO_ADRESSS_FLV @"http://bilibili-service.daoapp.io/videoflv/"     //视屏播放地址
#define URL_OF_VEDIO_ADRESSS_MP4 @"http://bilibili-service.daoapp.io/video/"     //视屏播放地址
#define URL_OF_VEDIO_MASSAGE @"http://bilibili-service.daoapp.io/view/"         //视频信息获取

#define SCREEN_WIDTH CGRectGetWidth(self.view.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(self.view.bounds)

@interface VedioPlayViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
//声明一个视屏播放器
@property (nonatomic, strong) AVPlayerViewController *videoPlayer;
//声明一个滚动视图 来存放视屏信息
@property (nonatomic, strong) UIScrollView *massageOfVideo;
//声明一个选集用的collationView
@property (nonatomic, strong) UICollectionView *collectionView;
//数据源数组 选集按钮
@property (nonatomic, strong) NSMutableArray *dataSource;
//声明一个label放视频标题
@property (nonatomic, strong) UILabel *titleForVideo;
//声明一个label放视屏介绍
@property (nonatomic, strong) UILabel *intruduceForVideo;
//声明一个字典 来取list
@property (nonatomic, strong) NSMutableDictionary *list;
//收藏按钮
@property (nonatomic, strong) UIButton *bottomBut;

@end
@implementation VedioPlayViewController

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_videoPlayer.player pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏前景色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //关掉透视效果
    self.automaticallyAdjustsScrollViewInsets = NO;
    //加载控件
    [self loadContrellers];
    //加载数据
    [self loadDataSource];
    //当app被挡住时 暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appHid:) name:UIApplicationWillResignActiveNotification object:nil];
    //当app置顶 开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)appHid:(NSNotification *)noti {
    _videoPlayer = [[AVPlayerViewController alloc] init];
}
- (void)appAppear:(NSNotification *)noti {
    [_videoPlayer.player play];
}
//加载控件
- (void)loadContrellers {
    //初始化滚动视图
    _massageOfVideo = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + SCREEN_HEIGHT / 3, SCREEN_WIDTH, SCREEN_HEIGHT * 2 / 3 - 64 - 34)];
    [self.view addSubview:_massageOfVideo];
    //初始化标题
    _titleForVideo = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
    _titleForVideo.layer.cornerRadius = 10;
    _titleForVideo.clipsToBounds = YES;
    _titleForVideo.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    _titleForVideo.textColor = [UIColor whiteColor];
    _titleForVideo.font = [UIFont systemFontOfSize:14];
    [_massageOfVideo addSubview:_titleForVideo];
    //初始化视频介绍label
    _intruduceForVideo = [[UILabel alloc] init];
    _intruduceForVideo.numberOfLines = 0;
    _intruduceForVideo.backgroundColor = [UIColor whiteColor];
    _intruduceForVideo.layer.cornerRadius = 10;
    _intruduceForVideo.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _intruduceForVideo.layer.borderWidth = 1;
    _intruduceForVideo.clipsToBounds = YES;
    _intruduceForVideo.font = [UIFont systemFontOfSize:14];
    [_massageOfVideo addSubview:_intruduceForVideo];
    
    //初始化数据源
    _dataSource = [NSMutableArray array];
    //初始化_collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //全局设置每个item的尺寸
    layout.itemSize = CGSizeMake(60, 30);
    //指定item之间的最小间隔
    layout.minimumInteritemSpacing = 10;
    //指定最小行距
    layout.minimumLineSpacing = 5;
    //设置header
    layout.headerReferenceSize = CGSizeMake(320, 0);
    //设置footer
    layout.footerReferenceSize = CGSizeMake(320, 0);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 5) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    //设置内偏移量
    _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    //注册cell
    [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册header
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //注册footer
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [_massageOfVideo addSubview:_collectionView];
    
    //初始化视频播放器
    _videoPlayer = [[AVPlayerViewController alloc] init];
    //设置播放器尺寸
    _videoPlayer.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT / 3);
    //添加播放器的控制器
    [self addChildViewController:_videoPlayer];
    //添加播放器的视图
    [self.view addSubview:_videoPlayer.view];
    
    _bottomBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBut.frame = CGRectMake(SCREEN_WIDTH / 4, SCREEN_HEIGHT - 30 - 2, SCREEN_WIDTH / 2, 30);
    _bottomBut.tintColor = [UIColor whiteColor];
    _bottomBut.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    _bottomBut.layer.cornerRadius = 10;
    _bottomBut.clipsToBounds = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"didLoginAccount"];
        NSString *key = [NSString stringWithFormat:@"av%@",_avNumber];
        NSString *strKeyNew = [NSString stringWithFormat:@"coll%@",str];
        
        AVQuery *query = [AVQuery queryWithClassName:@"CollectionForAccont"];
        AVObject *post = [query getObjectWithId:@"56a85854a633bd02579ac3c2"];
        NSDictionary *dic = [post objectForKey:strKeyNew];
        
        if (dic[key]) {
            [_bottomBut setTitle:@"已收藏" forState:UIControlStateNormal];
        } else {
            [_bottomBut setTitle:@"收藏本视屏" forState:UIControlStateNormal];
        }
    } else {
        NSString *key = [NSString stringWithFormat:@"av%@",_avNumber];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
            [_bottomBut setTitle:@"已收藏" forState:UIControlStateNormal];
        } else {
            [_bottomBut setTitle:@"收藏本视屏" forState:UIControlStateNormal];
        }
    }
    
    [_bottomBut addTarget:self action:@selector(collectVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBut];
}

- (void)loadDataSource {
    __weak typeof(self) weakSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", URL_OF_VEDIO_MASSAGE, _avNumber];
    _list = [NSMutableDictionary dictionary];
    [NetRequest GET:urlString parameters:nil success:^(id resposeObject) {
        //        NSLog(@"%@",resposeObject);
        _list = resposeObject[@"list"];
        //加载视屏信息
        [weakSelf loadVideoMassage:resposeObject];
        [NetRequest GET:[NSString stringWithFormat:@"%@%@/quailty[2]",URL_OF_VEDIO_ADRESSS_MP4,resposeObject[@"list"][@"0"][@"cid"]] parameters:nil success:^(id resposeObject) {
            NSLog(@"%@",resposeObject);
            _videoPlayer.player = [AVPlayer playerWithURL:[NSURL URLWithString:resposeObject[@"url"]]];
            [_videoPlayer.player play];
        } failure:^(NSError *error) {
            if (_videoAddress) {
                UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"本播放器暂不支持该视频格式 您可以通过下方链接跳转到safari观看：" message:_videoAddress preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:_videoAddress];
                    SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:url];
                    [self showViewController:sfVC sender:self];
                }];
                UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alterController addAction:sure];
                [alterController addAction:cancelItem];
                [self presentViewController:alterController animated:YES completion:nil];
            } else {
                UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"暂无资源" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alterController addAction:cancelItem];
                [self presentViewController:alterController animated:YES completion:nil];
            }
        }];
    } failure:^(NSError *error) {
        //        NSLog(@"视屏信息加载失败");
        UILabel *titleForVideo = [[UILabel alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT / 3 + 64 + 10, SCREEN_WIDTH - 20, 30)];
        titleForVideo.layer.cornerRadius = 10;
        titleForVideo.clipsToBounds = YES;
        titleForVideo.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
        titleForVideo.textColor = [UIColor whiteColor];
        titleForVideo.textAlignment = NSTextAlignmentCenter;
        titleForVideo.text = @"视屏信息加载失败";
        titleForVideo.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:titleForVideo];
    }];
}

- (void)loadVideoMassage:(id)resposeObject {
    
    _titleForVideo.text = [NSString stringWithFormat:@"  %@",resposeObject[@"title"]];
    
    UILabel *introduceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, SCREEN_WIDTH, 20)];
    introduceTitle.text = @"视屏简介:";
    introduceTitle.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    introduceTitle.font = [UIFont systemFontOfSize:14];
    [_massageOfVideo addSubview:introduceTitle];
    
    //自适应的标签
    CGSize size = [self sizeWithString:resposeObject[@"description"] font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT)];
    
    _intruduceForVideo.frame = CGRectMake(10, 70, SCREEN_WIDTH - 20, size.height);
    _intruduceForVideo.text = resposeObject[@"description"];
    
    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + _intruduceForVideo.bounds.size.height + 10 + 20, SCREEN_WIDTH, 20)];
    selectLabel.text = @"选集:";
    selectLabel.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    selectLabel.font = [UIFont systemFontOfSize:14];
    [_massageOfVideo addSubview:selectLabel];
    
    //给数据源赋值
    NSMutableDictionary *dic = resposeObject[@"list"];
    NSInteger butNum = dic.count;
    for (NSInteger index = 0; index < butNum; index ++) {
        NSString *string = [NSString stringWithFormat:@"part%ld",index + 1];
        [_dataSource addObject:string];
    }
    [_collectionView reloadData];
    //调整collection view大小
    _collectionView.frame = CGRectMake(0, 20 + 30 + 20 + _intruduceForVideo.bounds.size.height + 10 + 20, SCREEN_WIDTH, SCREEN_HEIGHT / 5);
    
    _massageOfVideo.contentSize = CGSizeMake(SCREEN_WIDTH, 30 + 30 + 20 + _intruduceForVideo.bounds.size.height + SCREEN_HEIGHT / 5 + 50);
}
#pragma mark --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    cell.titleOfBut.text = _dataSource[indexPath.row];
    return cell;
}
//cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
    [NetRequest GET:[NSString stringWithFormat:@"%@%@/quailty[3]",URL_OF_VEDIO_ADRESSS_MP4,_list[index][@"cid"]] parameters:nil success:^(id resposeObject) {
        _videoPlayer.player = [AVPlayer playerWithURL:[NSURL URLWithString:resposeObject[@"url"]]];
        [_videoPlayer.player play];
    } failure:^(NSError *error) {
        if (_videoAddress) {
            UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"本播放器暂不支持该视频格式 您可以通过下方链接跳转到safari观看：" message:_videoAddress preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:_videoAddress];
                SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:url];
                [self showViewController:sfVC sender:self];
            }];
            UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alterController addAction:sure];
            [alterController addAction:cancelItem];
            [self presentViewController:alterController animated:YES completion:nil];
        } else {
            UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"暂无资源" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alterController addAction:cancelItem];
            [self presentViewController:alterController animated:YES completion:nil];
        }
    }];
}
//自定义方法，文本自适应
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize {
    CGRect rect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size;
}
//收藏按钮
- (void)collectVideo:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"didLoginAccount"];
        NSString *key = [NSString stringWithFormat:@"av%@",_avNumber];
        
        AVQuery *query = [AVQuery queryWithClassName:@"CollectionForAccont"];
        AVObject *post = [query getObjectWithId:@"56a85854a633bd02579ac3c2"];
        NSString *strKeyNew = [NSString stringWithFormat:@"coll%@",str];
        NSDictionary *dic = [post objectForKey:strKeyNew];
        if (!dic[key]) {
            NSLog(@"收藏在线");
            //    title; face; typeName; created_at;
            NSMutableDictionary *saveData = [[NSMutableDictionary alloc] init];
            [NetRequest GET:[NSString stringWithFormat:@"%@%@",URL_OF_VEDIO_MASSAGE,_avNumber] parameters:nil success:^(id resposeObject) {
                //        NSLog(@"%@",resposeObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saveData setObject:resposeObject[@"title"] forKey:@"title"];
                    [saveData setObject:resposeObject[@"face"] forKey:@"face"];
                    [saveData setObject:resposeObject[@"typename"] forKey:@"typeName"];
                    [saveData setObject:resposeObject[@"created_at"] forKey:@"create"];
                    
                    AVQuery *query = [AVQuery queryWithClassName:@"CollectionForAccont"];
                    AVObject *post = [query getObjectWithId:@"56a85854a633bd02579ac3c2"];
                    
                    
                    NSMutableDictionary *dic = [[post objectForKey:strKeyNew] mutableCopy];
                    [dic setObject:saveData forKey:key];
                    
                    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        [post setObject:dic forKey:strKeyNew];
                        [post saveInBackground];
                    }];
                    
                    [_bottomBut setTitle:@"已收藏" forState:UIControlStateNormal];
                });
            } failure:^(NSError *error) {
                
            }];
            
        } else {
            NSLog(@"取消收藏");
            AVQuery *query = [AVQuery queryWithClassName:@"CollectionForAccont"];
            AVObject *post = [query getObjectWithId:@"56a85854a633bd02579ac3c2"];
            NSString *strKeyNew = [NSString stringWithFormat:@"coll%@",str];
            NSMutableDictionary *dic = [[post objectForKey:strKeyNew] mutableCopy];
            [dic removeObjectForKey:key];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [post setObject:dic forKey:strKeyNew];
                [post saveInBackground];
            }];
            
            [_bottomBut setTitle:@"收藏本视屏" forState:UIControlStateNormal];
        }
    } else {
        NSString *key = [NSString stringWithFormat:@"av%@",_avNumber];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
            NSLog(@"收藏");
            //    title; face; typeName; created_at;
            NSMutableDictionary *saveData = [[NSMutableDictionary alloc] init];
            [NetRequest GET:[NSString stringWithFormat:@"%@%@",URL_OF_VEDIO_MASSAGE,_avNumber] parameters:nil success:^(id resposeObject) {
                //        NSLog(@"%@",resposeObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saveData setObject:resposeObject[@"title"] forKey:@"title"];
                    [saveData setObject:resposeObject[@"face"] forKey:@"face"];
                    [saveData setObject:resposeObject[@"typename"] forKey:@"typeName"];
                    [saveData setObject:resposeObject[@"created_at"] forKey:@"create"];
                    //数据存到NSUserDefaults
                    
                    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:key];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //NSUserDefaults的关键字存到另一个NSUserDefaults
                    NSMutableArray *arrForKeys = [[[NSUserDefaults standardUserDefaults] objectForKey:@"all_avnumber"] mutableCopy];
                    //                NSLog(@"%@",arrForKeys);
                    [arrForKeys addObject:key];
                    //                NSLog(@"%@",arrForKeys);
                    [[NSUserDefaults standardUserDefaults] setObject:arrForKeys forKey:@"all_avnumber"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [_bottomBut setTitle:@"已收藏" forState:UIControlStateNormal];
                });
            } failure:^(NSError *error) {
                
            }];
            
        } else {
            NSLog(@"取消收藏");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //删除all_avnumber 中对应的key
            NSMutableArray *arrForKeys = [[[NSUserDefaults standardUserDefaults] objectForKey:@"all_avnumber"] mutableCopy];
            [arrForKeys removeObject:key];
            [[NSUserDefaults standardUserDefaults] setObject:arrForKeys forKey:@"all_avnumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [_bottomBut setTitle:@"收藏本视屏" forState:UIControlStateNormal];
        }
    }
    
    
}



@end
