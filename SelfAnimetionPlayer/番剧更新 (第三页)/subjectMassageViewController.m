//
//  subjectMassageViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/21.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "VedioPlayViewController.h"
#import "subjectMassageViewController.h"
#import "CustomCollectionViewCell.h"
#import "NetRequest.h"
#import "UIImageView+WebCache.h"
#define MASSAGE_NEW_ANIME_VIDEO @"http://bilibili-service.daoapp.io/spinfo/"//专题信息获取
#define VIDEO_NEW_ANIME_VIDEO @"http://bilibili-service.daoapp.io/spvideos/"//专题视屏获取
#define SCREEN_WIDTH CGRectGetWidth(self.view.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(self.view.bounds)

@interface subjectMassageViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
//声明一个imageView来放封面
@property (nonatomic, strong) UIImageView *cover;
//声明一个选集用的collationView
@property (nonatomic, strong) UICollectionView *collectionView;
//数据源数组 选集按钮
@property (nonatomic, strong) NSMutableArray *dataSource;
//声明一个label放视屏介绍
@property (nonatomic, strong) UILabel *intruduceForVideo;
//声明一个字典
@property (nonatomic, strong) NSMutableDictionary *dic;
//声明一个数组
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation subjectMassageViewController
- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏前景色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //隐藏返回按钮标题
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self loadNetSource];
    [self loadViews];
}
//加载视图控件
- (void)loadViews {
    //初始化数据源
    _dataSource = [NSMutableArray array];
    //
    //
    _cover = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 10, SCREEN_WIDTH / 3, SCREEN_HEIGHT / 5)];
    _cover.layer.cornerRadius = 10;
    _cover.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _cover.layer.borderWidth = 1;
    _cover.clipsToBounds = YES;
    [self.view addSubview:_cover];
    UIButton *bottomBut = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBut.frame = CGRectMake(SCREEN_WIDTH / 4, SCREEN_HEIGHT - 30 - 2, SCREEN_WIDTH / 2, 30);
    bottomBut.tintColor = [UIColor whiteColor];
    bottomBut.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    bottomBut.layer.cornerRadius = 10;
    bottomBut.clipsToBounds = YES;
    [bottomBut setTitle:@"收藏专题" forState:UIControlStateNormal];
    [self.view addSubview:bottomBut];
    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10 + SCREEN_HEIGHT / 5, SCREEN_WIDTH, 20)];
    selectLabel.text = @"选集:";
    selectLabel.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    selectLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:selectLabel];
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + 10 + SCREEN_HEIGHT / 5 + 20, SCREEN_WIDTH, SCREEN_HEIGHT / 8) collectionViewLayout:layout];
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
    [self.view addSubview:_collectionView];
    UILabel *introduceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10 + SCREEN_HEIGHT / 5 + 20 + SCREEN_HEIGHT / 8, SCREEN_WIDTH, 20)];
    introduceTitle.text = @"视屏简介:";
    introduceTitle.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    introduceTitle.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:introduceTitle];
    //初始化视频介绍label
    _intruduceForVideo = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10 + SCREEN_HEIGHT / 5 + 40 + SCREEN_HEIGHT / 8, SCREEN_WIDTH - 20, 100)];
    _intruduceForVideo.numberOfLines = 0;
    _intruduceForVideo.backgroundColor = [UIColor whiteColor];
    _intruduceForVideo.layer.cornerRadius = 10;
    _intruduceForVideo.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _intruduceForVideo.layer.borderWidth = 1;
    _intruduceForVideo.clipsToBounds = YES;
    _intruduceForVideo.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_intruduceForVideo];
}
//获取网络数据
- (void)loadNetSource {
    //专题信息获取
    NSString *urlString = [NSString stringWithFormat:@"%@%@",MASSAGE_NEW_ANIME_VIDEO,_spit];
    NSLog(@"%@",urlString);
    [NetRequest GET:urlString parameters:nil success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        _dic = resposeObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_cover sd_setImageWithURL:[NSURL URLWithString:resposeObject[@"cover"]]];
            //自适应的标签
            CGSize size = [self sizeWithString:resposeObject[@"description"] font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT / 2 - 45)];
            _intruduceForVideo.frame = CGRectMake(10, 64 + 10 + SCREEN_HEIGHT / 5 + 40 + SCREEN_HEIGHT / 8, SCREEN_WIDTH - 20, size.height);
            _intruduceForVideo.text = resposeObject[@"description"];
        });
    } failure:^(NSError *error) {
        //自适应的标签
        CGSize size = [self sizeWithString:@"加载失败" font:[UIFont systemFontOfSize:17] maxSize:CGSizeMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT / 2 - 30)];
        _intruduceForVideo.frame = CGRectMake(10, 64 + 10 + SCREEN_HEIGHT / 5 + 40 + SCREEN_HEIGHT / 8, SCREEN_WIDTH - 20, size.height);
        _intruduceForVideo.text = @"加载失败";
    }];
    //专题视屏获取
    NSString *urlString2 = [NSString stringWithFormat:@"%@%@",VIDEO_NEW_ANIME_VIDEO,_spit];
    NSLog(@"%@",urlString2);
    [NetRequest GET:urlString2 parameters:nil success:^(id resposeObject) {
        NSLog(@"%@",resposeObject);
        _list = resposeObject[@"list"];
        NSMutableDictionary *dic = resposeObject[@"list"];
        NSInteger butNum = dic.count;
        if (butNum) {
            for (NSInteger index = 0; index < butNum; index ++) {
                NSString *string = [NSString stringWithFormat:@"part%ld",index + 1];
                [_dataSource addObject:string];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        } else {
            UILabel *titleForVideo = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10 + SCREEN_HEIGHT / 5 + 20, SCREEN_WIDTH - 20, 30)];
            titleForVideo.layer.cornerRadius = 10;
            titleForVideo.clipsToBounds = YES;
            titleForVideo.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
            titleForVideo.textColor = [UIColor whiteColor];
            titleForVideo.textAlignment = NSTextAlignmentCenter;
            titleForVideo.text = @"暂无资源";
            titleForVideo.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:titleForVideo];
        }
        
    } failure:^(NSError *error) {
        UILabel *titleForVideo = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10 + SCREEN_HEIGHT / 5 + 20, SCREEN_WIDTH - 20, 30)];
        titleForVideo.layer.cornerRadius = 10;
        titleForVideo.clipsToBounds = YES;
        titleForVideo.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
        titleForVideo.textColor = [UIColor whiteColor];
        titleForVideo.textAlignment = NSTextAlignmentCenter;
        titleForVideo.text = @"加载失败";
        titleForVideo.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:titleForVideo];
    }];
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
//自定义方法，文本自适应
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize {
    CGRect rect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size;
}
//cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = _dic[@"title"];
    //初始化视屏播放界面
    VedioPlayViewController *VedioPlayVC = [[VedioPlayViewController alloc] initWithTitle:title];
    VedioPlayVC.hidesBottomBarWhenPushed = YES;
    VedioPlayVC.avNumber = _list[indexPath.row][@"aid"];
    [self.navigationController pushViewController:VedioPlayVC animated:YES];
}
@end
