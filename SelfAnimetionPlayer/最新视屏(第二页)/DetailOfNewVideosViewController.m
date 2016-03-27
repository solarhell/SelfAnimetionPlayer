//
//  DetailOfNewVideosViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/20.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "DetailOfNewVideosViewController.h"
#import "NewVideosCustomCollectionViewCell.h"
#import "VedioPlayViewController.h"
#import "NetRequest.h"
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH CGRectGetWidth(self.view.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(self.view.bounds)

#define URL_OF_ALL_VIDEO @"http://bilibili-service.daoapp.io/sort/"

@interface DetailOfNewVideosViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
//数据源数组
@property (nonatomic, strong) NSMutableDictionary *dataSource;
//
@property (nonatomic, strong) UICollectionView *collectionView;
/**************************视屏播放界面***************************/
@property (nonatomic, strong) VedioPlayViewController *VedioPlayVC;
//加载页数
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation DetailOfNewVideosViewController

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _pageNum = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题颜色,字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:[ NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:20.0],NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //隐藏返回按钮标题
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //导航栏前景色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //网络请求
    [self loadNetSourceFromPage:@"1"];
    //加载视图
    [self loadCollectionView];
}
//加载视图
- (void)loadCollectionView {
    //配置collection view布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //全局设置每个item的尺寸
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 15, SCREEN_HEIGHT / 5);
    //指定item之间的最小间隔
    layout.minimumInteritemSpacing = 10;
    //指定最小行距
    layout.minimumLineSpacing = 10;
    //设置header
    layout.headerReferenceSize = CGSizeMake(0, 0);
    //设置footer
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    //根据配置类初始化collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    //设置内偏移量
    _collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    //注册cell
    [_collectionView registerClass:[NewVideosCustomCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册header
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //注册footer
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_collectionView];
}
//获取网络数据
- (void)loadNetSourceFromPage:(NSString *)page {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",URL_OF_ALL_VIDEO,_strOfClass];
    NSDictionary *parameter = @{@"page":page, @"count":@"10", @"order":@"new"};
    [NetRequest GET:urlString parameters:parameter success:^(id resposeObject) {
//        NSLog(@"%@",resposeObject);
        if (_pageNum == 1) {
            _dataSource = [resposeObject[@"list"] mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSInteger index = 0; index < 10; index ++) {
                [_dataSource setValue:resposeObject[@"list"][[NSString stringWithFormat:@"%ld",index]] forKey:[NSString stringWithFormat:@"%ld",(_pageNum - 1) * 10 + index]];
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:(_pageNum - 1) * 10 + index inSection:0];
                [array addObject:indexPath];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView insertItemsAtIndexPaths:array];
            });
//            NSLog(@"%@",array);
        }
    } failure:^(NSError *error) {
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"加载失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alterController addAction:cancelItem];
        [self presentViewController:alterController animated:YES completion:nil];
    }];
}
#pragma mark --- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewVideosCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    
    cell.layer.backgroundColor = [UIColor colorWithRed:0.8438 green:0.8394 blue:0.8482 alpha:0.5].CGColor;
    cell.imageView.frame = CGRectMake(5, 5, cell.bounds.size.width - 10, cell.bounds.size.height * 3 / 4);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dataSource[[NSString stringWithFormat:@"%ld",indexPath.row]][@"pic"]]];
    cell.titleLabel.frame = CGRectMake(5, 5 + cell.bounds.size.height * 3 / 4, cell.bounds.size.width - 10, cell.bounds.size.height * 1 / 8);
    cell.titleLabel.text = _dataSource[[NSString stringWithFormat:@"%ld",indexPath.row]][@"title"];
    cell.createTimeLabel.frame = CGRectMake(5, cell.bounds.size.height * 3 / 4 + cell.bounds.size.height * 1 / 8, cell.bounds.size.width - 10, cell.bounds.size.height * 1 / 8);
    cell.createTimeLabel.text = _dataSource[[NSString stringWithFormat:@"%ld",indexPath.row]][@"create"];
    cell.label.frame = CGRectMake(0, 0, 0, 0);
    if (indexPath.row == _dataSource.count - 1) {
        cell.label.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 25);
        cell.imageView.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabel.frame = CGRectMake(0, 0, 0, 0);
        cell.createTimeLabel.frame = CGRectMake(0, 0, 0, 0);
        cell.label.text = @"加载更多";
        cell.layer.backgroundColor = [UIColor whiteColor].CGColor;
        return cell;
    }
    return cell;
}
//cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataSource.count - 1) {
        _pageNum ++;
//        NSLog(@"%ld",_pageNum);
        [self loadNetSourceFromPage:[NSString stringWithFormat:@"%ld",_pageNum]];
        return;
    }
    //初始化视屏播放界面
    NSString *title = _dataSource[[NSString stringWithFormat:@"%ld",indexPath.row]][@"title"];
    _VedioPlayVC = [[VedioPlayViewController alloc] initWithTitle:title];
    _VedioPlayVC.hidesBottomBarWhenPushed = YES;
    _VedioPlayVC.avNumber = _dataSource[[NSString stringWithFormat:@"%ld",indexPath.row]][@"aid"];
    [self.navigationController pushViewController:_VedioPlayVC animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataSource.count - 1) {
        return CGSizeMake(SCREEN_WIDTH - 20, 25);
    }
    return CGSizeMake(SCREEN_WIDTH / 2 - 15, SCREEN_HEIGHT / 5);
}
@end
