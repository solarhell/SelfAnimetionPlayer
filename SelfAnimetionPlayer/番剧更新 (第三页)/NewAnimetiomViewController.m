//
//  NewAnimetiomViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/16.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "NewAnimetiomViewController.h"
#import "subjectMassageViewController.h"
#import "NetRequest.h"
#define NEW_ANIME_VIDEO @"http://bilibili-service.daoapp.io/bangumi?btype=2"
#define SCREEN_WIDTH CGRectGetWidth(self.view.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(self.view.bounds)

@interface NewAnimetiomViewController () <UITableViewDataSource,UITableViewDelegate>
//声明一个数组 取出番剧更新列表
@property (nonatomic, strong) NSMutableDictionary *getMassageFromNet;
//声明表格式图
@property (nonatomic, strong) UITableView *tableView;
//声明一个下拉控件
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation NewAnimetiomViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"连载更新";
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"连载" image:[UIImage imageNamed:@"newAnime"] tag:200];
        self.tabBarItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题颜色,字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:[ NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:20.0],NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //自定义导航栏 背景色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    //隐藏返回按钮标题
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //获取网络数据
    [self loadNetSource];
    
    //初始化表格式图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //行高，默认为44
    _tableView.rowHeight = 40;
    //数据源协议
    _tableView.dataSource = self;
    //一般协议
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    //初始化下拉刷新控件
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新"];
    [_refreshControl addTarget:self action:@selector(beginRefreshData) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}
//实现下拉刷新
- (void)beginRefreshData {
    [self performSelector:@selector(loadNetSource) withObject:nil afterDelay:2];
}
//获取网络数据
- (void)loadNetSource {
    [_refreshControl endRefreshing];
    _getMassageFromNet = [[NSMutableDictionary alloc] init];
    //番剧更新列表
    [NetRequest GET:NEW_ANIME_VIDEO parameters:nil success:^(id resposeObject) {
//        NSLog(@"%@",resposeObject);
        _getMassageFromNet = [resposeObject mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    } failure:^(NSError *error) {

    }];
}

#pragma mark -- UITableViewDataSource
//返回多个分区，默认返回一个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}
//必须实现：返回表格指定分区有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = @{@0:@"0", @1:@"1", @2:@"2", @3:@"3", @4:@"4", @5:@"5", @6:@"-1"};
    NSArray *array = _getMassageFromNet[dic[@(section)]];
    return array.count;
}
//必须实现：配置每一行的cell怎么显示，返回当前行的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = @{@0:@"0", @1:@"1", @2:@"2", @3:@"3", @4:@"4", @5:@"5", @6:@"-1"};
    //定义一个可重用标识符
    static NSString *cellIdentifer = @"fontListcell";
    //从可重用队列中取出一个cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifer];
    }
    cell.textLabel.text = _getMassageFromNet[dic[@(indexPath.section)]][indexPath.row][@"title"];
    cell.textLabel.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"最后更新于%@", _getMassageFromNet[dic[@(indexPath.section)]][indexPath.row][@"lastupdate_at"]];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    return cell;
}
//配置一般协议
//标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}
//自定义标题栏
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *array = @[@"❀❀❀ 星期日 ❀❀❀",@"❀❀❀ 星期一 ❀❀❀",@"❀❀❀ 星期二 ❀❀❀",@"❀❀❀ 星期三 ❀❀❀",@"❀❀❀ 星期四 ❀❀❀",@"❀❀❀ 星期五 ❀❀❀",@"❀❀❀ 星期六 ❀❀❀"];
    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 30)];
    view.text = array[section];
    view.backgroundColor = [UIColor whiteColor];
    view.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    view.textAlignment = NSTextAlignmentCenter;
    return view;
}
//点击每一行cell时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = @{@0:@"0", @1:@"1", @2:@"2", @3:@"3", @4:@"4", @5:@"5", @6:@"-1"};
    //取消选中时改变的颜色
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    subjectMassageViewController *subjectMVC = [[subjectMassageViewController alloc] initWithTitle:_getMassageFromNet[dic[@(indexPath.section)]][indexPath.row][@"title"]];
    subjectMVC.hidesBottomBarWhenPushed = YES;
    subjectMVC.spit = _getMassageFromNet[dic[@(indexPath.section)]][indexPath.row][@"spid"];
    [self.navigationController pushViewController:subjectMVC animated:YES];
}


@end
