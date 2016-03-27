//
//  RankingListViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/16.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "RankingListViewController.h"
#import "DetailOfNewVideosViewController.h"
#import "CustomTableViewCell.h"
#import "VedioPlayViewController.h"
#import "NetRequest.h"
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH CGRectGetWidth(self.view.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(self.view.bounds)
#define URL_OF_HOME_PAGE @"http://bilibili-service.daoapp.io/search"

@interface RankingListViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>
//数据源数组
@property (nonatomic, strong) NSMutableArray *dataSource;
//搜索用文本框
@property (nonatomic, strong) UITextField *searchForVideo;
//声明表格式图
@property (nonatomic, strong) UITableView *tableView;
//声明数据源字典
@property (nonatomic, strong) NSMutableArray *searchSource;
/**************************视屏播放界面***************************/
@property (nonatomic, strong) VedioPlayViewController *VedioPlayVC;

@end

@implementation RankingListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"最新视屏";
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"最新" image:[UIImage imageNamed:@"rankingPage"] tag:200];
        self.tabBarItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题颜色,字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:[ NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:20.0],NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //隐藏返回按钮标题
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //自定义导航栏 背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    
    //加载数据源
    NSArray *className = @[@"游戏",@"电影",@"番剧",@"动画",@"电视剧",@"音乐",@"鬼畜",@"娱乐",@"舞蹈",@"科技"];
    _dataSource = [className mutableCopy];
    [self loadCollectionView];
    //顶部添加搜索用文本框
    UILabel *labelBGC = [[UILabel alloc] initWithFrame:CGRectMake(10, 69, SCREEN_WIDTH - 20, 30)];
    labelBGC.backgroundColor = [UIColor whiteColor];
    labelBGC.layer.cornerRadius = 11;
    labelBGC.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    labelBGC.layer.borderWidth = 1;
    labelBGC.clipsToBounds = YES;
    [self.view addSubview:labelBGC];
    _searchForVideo = [[UITextField alloc] initWithFrame:CGRectMake(25, 70, SCREEN_WIDTH - 75, 30)];
    _searchForVideo.placeholder = @"全站视屏搜索";
    _searchForVideo.delegate = self;
    _searchForVideo.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    _searchForVideo.tintColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    _searchForVideo.font = [UIFont systemFontOfSize:14];
    _searchForVideo.clearButtonMode = YES;
    [self.view addSubview:_searchForVideo];
    UIButton *searchBut = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 13 - 40, 71, 40, 26)];
    [searchBut setTitle:@"搜索" forState:UIControlStateNormal];
    searchBut.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    searchBut.layer.cornerRadius = 10;
    searchBut.clipsToBounds = YES;
    searchBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBut addTarget:self action:@selector(searchForVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBut];
    //加载搜索tableview
    [self loadSearhTableView];
}
#pragma mark --- 获取数据
- (void)loadNetSourceByString:(NSString *)string {
    NSDictionary *parameter = @{@"page": @"1", @"count": @"20",@"content":string};
    
    [NetRequest POST:URL_OF_HOME_PAGE parameters:parameter success:^(id resposeObject) {
//        NSLog(@"%@",resposeObject[@"result"][@"video"]);
        _searchSource = [resposeObject[@"result"][@"video"] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    } failure:^(NSError *error) {
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"加载失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alterController addAction:cancelItem];
        [self presentViewController:alterController animated:YES completion:nil];
    }];
}
//SCREEN_HEIGHT - 69 - 35 - 49
- (void)loadSearhTableView {
    _searchSource = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 69 + 35, SCREEN_WIDTH, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
}
//数据源协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //定义可重用标识符
    static NSString *cellIdentifer = @"cell";
    //从可重用队列里取出一个cell
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    [cell.logoImageView sd_setImageWithURL:_searchSource[indexPath.row][@"pic"]];
    cell.videoTitle.text = _searchSource[indexPath.row][@"title"];
    cell.duration.text = [NSString stringWithFormat:@"时长%@", _searchSource[indexPath.row][@"duration"]];
    cell.className.text = _searchSource[indexPath.row][@"typename"];
    cell.createTime.text = _searchSource[indexPath.row][@"tag"];
    return cell;
}
//delegate协议  点击cell响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中的颜色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _VedioPlayVC = [[VedioPlayViewController alloc] initWithTitle:_searchSource[indexPath.row][@"title"]];
    _VedioPlayVC.hidesBottomBarWhenPushed = YES;
    _VedioPlayVC.avNumber = _searchSource[indexPath.row][@"aid"];
    [self.navigationController pushViewController:_VedioPlayVC animated:YES];
}
//
//
- (void)loadCollectionView {
    //配置collection view布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //全局设置每个item的尺寸
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 6, SCREEN_WIDTH / 5);
    //指定item之间的最小间隔
    layout.minimumInteritemSpacing = SCREEN_WIDTH / 10;
    //指定最小行距
    layout.minimumLineSpacing = SCREEN_WIDTH / 8;
    //设置header
    layout.headerReferenceSize = CGSizeMake(0, 0);
    //设置footer
    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    //根据配置类初始化collection view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    //设置内偏移量
    collectionView.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH / 6, SCREEN_WIDTH / 10, 10, SCREEN_WIDTH / 10);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册header
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //注册footer
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:collectionView];
}
#pragma mark --- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    UIImageView *classImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH / 6 - 10, SCREEN_WIDTH / 6 - 10)];
    classImageView.image = [UIImage imageNamed:_dataSource[indexPath.row]];
    UILabel *classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, SCREEN_WIDTH / 6 - 5, SCREEN_WIDTH / 6 - 10, SCREEN_WIDTH / 5 - SCREEN_WIDTH / 6)];
    classNameLabel.textAlignment = NSTextAlignmentCenter;
    classNameLabel.textColor = [UIColor whiteColor];
    classNameLabel.text = _dataSource[indexPath.row];
    classNameLabel.font = [UIFont systemFontOfSize:12];
    [cell addSubview:classNameLabel];
    [cell addSubview:classImageView];
    
    return cell;
}
//cell点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_searchForVideo resignFirstResponder];
    NSArray *className = @[@"游戏",@"电影",@"番剧",@"动画",@"电视剧",@"音乐",@"鬼畜",@"娱乐",@"舞蹈",@"科技"];
    NSDictionary *dic = @{@"游戏":@"4",@"电影":@"23",@"番剧":@"13",@"动画":@"1",@"电视剧":@"11",@"音乐":@"3",@"鬼畜":@"119",@"娱乐":@"5",@"舞蹈":@"129",@"科技":@"36"};
    DetailOfNewVideosViewController *DetailOfNewVC = [[DetailOfNewVideosViewController alloc] initWithTitle:_dataSource[indexPath.row]];
    DetailOfNewVC.hidesBottomBarWhenPushed = YES;
    DetailOfNewVC.strOfClass = dic[className[indexPath.row]];
    [self.navigationController pushViewController:DetailOfNewVC animated:YES];
    
}
//搜索按钮
- (void)searchForVideo:(UIButton *)sender {
    if (_searchForVideo.text.length == 0) {
        [_searchForVideo resignFirstResponder];
        return;
    }
    [_searchForVideo resignFirstResponder];
    //wangluoqingqiu
    [self loadNetSourceByString:_searchForVideo.text];
    [UIView animateWithDuration:0.5 animations:^{
        _tableView.frame = CGRectMake(0, 69 + 35, SCREEN_WIDTH, SCREEN_HEIGHT - 69 - 35 - 49);
    }];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [UIView animateWithDuration:0.5 animations:^{
        _tableView.frame = CGRectMake(0, 69 + 35, SCREEN_WIDTH, 0);
    }];
    return YES;
}
//回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchForVideo resignFirstResponder];
    return YES;
}

@end
