//
//  DetailForTop9ViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/17.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "DetailForTop9ViewController.h"
#import "VedioPlayViewController.h"
#import "CustomTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface DetailForTop9ViewController () <UITableViewDelegate, UITableViewDataSource>
//数据源 _contenst;
@property (nonatomic, strong) UITableView *tableView;
/**************************视屏播放界面***************************/
@property (nonatomic, strong) VedioPlayViewController *VedioPlayVC;

@end

@implementation DetailForTop9ViewController

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
    
    //初始化表格
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
    
//    NSLog(@"%@",_contenst);
}
//数据源协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contenst.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //定义可重用标识符
    static NSString *cellIdentifer = @"cell";
    //从可重用队列里取出一个cell
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    [cell.logoImageView sd_setImageWithURL:_contenst[indexPath.row][@"pic"]];
    cell.videoTitle.text = _contenst[indexPath.row][@"title"];
    cell.duration.text = [NSString stringWithFormat:@"时长%@", _contenst[indexPath.row][@"duration"]];
    cell.className.text = _contenst[indexPath.row][@"typename"];
    cell.createTime.text = _contenst[indexPath.row][@"create"];
    return cell;
}
//delegate协议  点击cell响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中的颜色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _VedioPlayVC = [[VedioPlayViewController alloc] initWithTitle:_contenst[indexPath.row][@"title"]];
    _VedioPlayVC.hidesBottomBarWhenPushed = YES;
    _VedioPlayVC.avNumber = _contenst[indexPath.row][@"aid"];
    [self.navigationController pushViewController:_VedioPlayVC animated:YES];
}
@end
