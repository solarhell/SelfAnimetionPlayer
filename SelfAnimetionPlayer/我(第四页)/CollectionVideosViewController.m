//
//  CollectionVideosViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/25.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "CollectionVideosViewController.h"
#import "VedioPlayViewController.h"
#import "CustomTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <AVOSCloud/AVOSCloud.h>

@interface CollectionVideosViewController () <UITableViewDelegate, UITableViewDataSource>
//数据源 _contenst;
@property (nonatomic, strong) UITableView *tableView;
/**************************视屏播放界面***************************/
@property (nonatomic, strong) VedioPlayViewController *VedioPlayVC;
//新建一个数据源数组
@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation CollectionVideosViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _sourceArray = [[NSMutableArray alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"didLogin"]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"didLoginAccount"];
        NSString *strKeyNew = [NSString stringWithFormat:@"coll%@",str];
        
        AVQuery *query = [AVQuery queryWithClassName:@"CollectionForAccont"];
        AVObject *post = [query getObjectWithId:@"56a85854a633bd02579ac3c2"];
        NSDictionary *dic = [post objectForKey:strKeyNew];
        _contenst = [[dic allKeys] mutableCopy];
        NSLog(@"%@",_contenst);
        _sourceArray = [[dic allValues] mutableCopy];
    } else {
        _contenst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"all_avnumber"] mutableCopy];
        for (NSInteger index = 0; index < _contenst.count; index ++) {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:_contenst[index]];
            [_sourceArray addObject:dic];
        }
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏前景色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"我的收藏";
    //隐藏返回按钮标题
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    //初始化表格
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
    
    
}
//数据源协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //定义可重用标识符
    static NSString *cellIdentifer = @"cell";
    //从可重用队列里取出一个cell
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    [cell.logoImageView sd_setImageWithURL:_sourceArray[indexPath.row][@"face"]];
    cell.videoTitle.text = _sourceArray[indexPath.row][@"title"];
    cell.duration.text = _sourceArray[indexPath.row][@"typeName"];
    cell.createTime.text = _sourceArray[indexPath.row][@"create"];
    return cell;
}
//delegate协议  点击cell响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中的颜色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _VedioPlayVC = [[VedioPlayViewController alloc] initWithTitle:_sourceArray[indexPath.row][@"title"]];
    _VedioPlayVC.hidesBottomBarWhenPushed = YES;
    NSString *str = [_contenst[indexPath.row] substringFromIndex:2];
    NSLog(@"%@",str);
    _VedioPlayVC.avNumber = str;
    [self.navigationController pushViewController:_VedioPlayVC animated:YES];
}

@end
