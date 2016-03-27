//
//  HomePageViewController.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/16.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "HomePageViewController.h"
#import "NetRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "TenHotVedioView.h"
#import "VedioPlayViewController.h"
#import "DetailForTop9ViewController.h"

#define SCREEN_WIDTH CGRectGetWidth(self.view.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(self.view.bounds)

#define URL_OF_HOME_PAGE @"http://bilibili-service.daoapp.io/indexinfo"         //顶部动态导视图
#define URL_OF_HOT_VEDIO @"http://bilibili-service.daoapp.io/topinfo"           //10各分类的9个热门视频

@interface HomePageViewController () <UIScrollViewDelegate>
//
@property (nonatomic, strong) UIImageView *wellCome;
//声明一个 scrollView 来放其他视图
@property (nonatomic, strong) UIScrollView *scrollView;
//
@property (nonatomic, strong) UILabel *refresh;
/*************************顶部滚动视图***************************/
//在这个底层滚动视图的最上方加一个横向的滚动视图 来循环滚动显示热门动画图片
@property (nonatomic, strong) UIScrollView *topScrollView;
//声明一个数来获取滚动图片的个数
@property (nonatomic, assign) NSUInteger numberOfTopViewImage;
//声明一个定时器 用于顶部标签的自动滚动
@property (nonatomic, strong) NSTimer *timerForAutoScorll;
//用于顶部滚动视图去bug
@property (nonatomic, assign) BOOL isAnimating;
//声明分页控制器
@property (nonatomic, strong) UIPageControl *pageControl;
//声明一个标志 标志是否已经点击 防止出现重复点击
@property (nonatomic, assign) BOOL didClip;
/*************************10个分类按钮***************************/
//声明一个字典 取出热门视屏信息
@property (nonatomic, strong) NSMutableDictionary *getresposeObject;
//返回顶部按钮
@property (nonatomic, strong) UIButton *backToTop;
/**************************视屏播放界面***************************/
@property (nonatomic, strong) VedioPlayViewController *VedioPlayVC;

@end

@implementation HomePageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"热门推荐";
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"热门" image:[UIImage imageNamed:@"homePage"] tag:200];
        self.tabBarItem = item;
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"homePage_selected"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _didClip = NO;
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
    //设置标签栏背景色 前景色
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    //关掉透视效果
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabBarController.tabBar.alpha = 0.0;
    self.navigationController.navigationBar.alpha = 0.0;
    self.navigationController.navigationBar.hidden = YES;
    
    //获取数据
    [self loadDataSource];
    //加载顶部滚动视图
    [self loadTopScrollView];
    //加载热门分类按钮
    [self loadButtonsForClass];
    _wellCome = [[UIImageView alloc] initWithFrame:self.view.frame];
    _wellCome.image = [UIImage imageNamed:@"wellcome.jpg"];
    [self.view addSubview:_wellCome];
    [self performSelector:@selector(hideTheWellPic) withObject:self afterDelay:1.5];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"all_avnumber"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:@"all_avnumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)hideTheWellPic {
    self.navigationController.navigationBar.alpha = 0.0;
    self.navigationController.navigationBar.hidden = NO;
    [UIView animateWithDuration:2 animations:^{
        _wellCome.alpha = 0.0;
        self.tabBarController.tabBar.alpha = 1.0;
        self.navigationController.navigationBar.alpha = 1.0;
    }];
}
#pragma mark --- 获取数据
- (void)loadDataSource {
    __weak typeof(self) weakSelf = self;
    /************************
            获取顶部图片
     ************************/
    [NetRequest GET:URL_OF_HOME_PAGE parameters:nil success:^(id resposeObject) {
//        NSLog(@"%@", resposeObject[@"result"][@"banners"]);
        //获取这个数组的长度 即顶部标签图片的数量
        NSArray *array = [NSArray arrayWithArray:resposeObject[@"result"][@"banners"]];
        _numberOfTopViewImage = array.count;
        //给顶部滚动视图添加内容
        [weakSelf addImagesToTopViewWithObject:resposeObject];
    } failure:^(NSError *error) {
        NSLog(@"导视加载失败");
    }];
    /****************************
        获取10各分类的9个热门视频,并加载到主滑动视图
     ****************************/
    _getresposeObject = [[NSMutableDictionary alloc] init];
    [NetRequest GET:URL_OF_HOT_VEDIO parameters:nil success:^(id resposeObject) {
//        NSLog(@"%@",resposeObject[@"游戏"]);
        //加载10个热门视屏分类区
        _getresposeObject = resposeObject;
        [weakSelf loadTenHotVedioClassFrom:resposeObject];
    } failure:^(NSError *error) {
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"热门视频加载失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alterController addAction:cancelItem];
        [self presentViewController:alterController animated:YES completion:nil];
    }];
}
//给顶部滚动视图添加内容
- (void)addImagesToTopViewWithObject:(id)resposeObject {
    //总页数
    _pageControl.numberOfPages = _numberOfTopViewImage;
    _topScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * (_numberOfTopViewImage + 2), SCREEN_HEIGHT / 5);
    for (NSInteger index = 0; index < _numberOfTopViewImage; index ++) {
        //给顶部的滚动视图添加图片以及对应的标签 标签用来介绍图片
        UIButton *topImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topImageButton.frame = CGRectMake(SCREEN_WIDTH * (index + 1), 0, SCREEN_WIDTH, SCREEN_HEIGHT / 5);
        [topImageButton sd_setImageWithURL:[NSURL URLWithString:resposeObject[@"result"][@"banners"][index][@"img"]] forState:UIControlStateNormal];
        topImageButton.tag = 500 + index;
        [topImageButton addTarget:self action:@selector(pushTOVadioPlayerVC:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:topImageButton];
    }
    UIImageView *imageViewFirst = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 5)];
    [imageViewFirst sd_setImageWithURL:[NSURL URLWithString:resposeObject[@"result"][@"banners"][_numberOfTopViewImage - 1][@"img"]]];
    [_topScrollView addSubview:imageViewFirst];
    UIImageView *imageViewLast = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH *(_numberOfTopViewImage + 1), 0, SCREEN_WIDTH, SCREEN_HEIGHT / 5)];
    [imageViewLast sd_setImageWithURL:[NSURL URLWithString:resposeObject[@"result"][@"banners"][0][@"img"]]];
    [_topScrollView addSubview:imageViewLast];
}
#pragma mark --- 加载控件
/****************************
        加载顶部滚动视图
 ****************************/
- (void)loadTopScrollView {
    //初始化滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64)];
    //设置屏宽
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT / 2.5 + 10 + (SCREEN_HEIGHT / 2.5 - 10) * 10);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.9131 green:0.8954 blue:0.9292 alpha:1.0];
    _scrollView.delegate = self;
    _scrollView.tag = 101;
    [self.view addSubview:_scrollView];
    
    UILabel *refresh = [[UILabel alloc] initWithFrame:CGRectMake(0, -45, SCREEN_WIDTH, 40)];
    refresh.text  = @"下拉刷新";
    refresh.textColor = [UIColor whiteColor];
    refresh.textAlignment = NSTextAlignmentCenter;
    refresh.layer.cornerRadius = 20;
    refresh.clipsToBounds = YES;
    refresh.backgroundColor = [UIColor colorWithRed:0.329 green:0.7413 blue:0.4058 alpha:0.5];
    self.refresh = refresh;
    refresh.tag = 0;
    [_scrollView addSubview:refresh];
    
    //在这个底层滚动视图的最上方加一个横向的滚动视图 来循环滚动显示热门动画图片
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 5)];
    _topScrollView.tag = 102;
    _topScrollView.backgroundColor = [UIColor lightGrayColor];
    //设置代理
    _topScrollView.delegate = self;
    //设置分页显示
    _topScrollView.pagingEnabled = YES;
    //设置开始显示的位置
    [_topScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    //隐藏滑条
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView addSubview:_topScrollView];
    //初始化分页控制器
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    _pageControl.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)/ 5 + 49);
    
    //当前指示页
    _pageControl.currentPage = 0;
    //设置颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    //设置分页控制器不可点击改变
    _pageControl.enabled = NO;
    [_scrollView addSubview:_pageControl];
    //初始化定时器
    _timerForAutoScorll = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoChangeScrollViewPage) userInfo:nil repeats:YES];
}
//自动播放
- (void)autoChangeScrollViewPage {
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    //通过改变偏移量来滚动scroll view
    [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentOffset.x + SCREEN_WIDTH, 0) animated:YES];
    //重置bool值
    [self performSelector:@selector(resetAnimation) withObject:nil afterDelay: 0.5];
}
//重置bool值
- (void)resetAnimation {
    _isAnimating = NO;
}
/**********************
     加载热门分类按钮
 **********************/
- (void)loadButtonsForClass {
    //声明一个数组来存放按钮名
    NSArray *buttonName = @[@"游戏",@"电影",@"番剧",@"动画",@"电视",@"音乐",@"鬼畜",@"娱乐",@"舞蹈",@"科技"];
    //用一个view做灰底背景
    UILabel *labelForButtonBackgroundColor = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT / 5 + 10, SCREEN_WIDTH, SCREEN_HEIGHT / 5)];
    labelForButtonBackgroundColor.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:labelForButtonBackgroundColor];
    //第一行
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(((SCREEN_WIDTH - 5 * 50) / 6)* (1 + index) + index * 50, SCREEN_HEIGHT / 5 + (SCREEN_WIDTH - 5 * 50) / 12 + 8.5, 50, 50);
        button.layer.cornerRadius = 25;
        [button setTitle:buttonName[index] forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
        [button addTarget:self action:@selector(jumpToOppositeLocate:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200 +index;
        [_scrollView addSubview:button];
    }
    //第二行
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(((SCREEN_WIDTH - 5 * 50) / 6)* (1 + index) + index * 50, SCREEN_HEIGHT / 5 + (SCREEN_WIDTH - 5 * 50) / 6 + 57, 50, 50);
        button.layer.cornerRadius = 25;
        [button setTitle:buttonName[index + 5] forState:UIControlStateNormal];
        button.tintColor = [UIColor whiteColor];
        button.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
        [button addTarget:self action:@selector(jumpToOppositeLocate:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 205 +index;
        [_scrollView addSubview:button];
    }
    //返回顶部按钮初始化
    _backToTop = [UIButton buttonWithType:UIButtonTypeCustom];
    _backToTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [_backToTop setTitle:@"返回顶部" forState:UIControlStateNormal];
    _backToTop.titleLabel.font = [UIFont systemFontOfSize:12];
    _backToTop.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    _backToTop.tintColor = [UIColor whiteColor];
    [_backToTop addTarget:self action:@selector(jumpToOppositeLocate:) forControlEvents:UIControlEventTouchUpInside];
    _backToTop.tag = 210;
    [self.view addSubview:_backToTop];
}
/**********************
 加载十个热门分类
 **********************/
- (void)loadTenHotVedioClassFrom:(id)resposeObject {
    //声明一个数组来存放标题名
    NSArray *titleName = @[@"『游戏-HOT9』",@"『电影-HOT9』",@"『番剧-HOT9』",@"『动画-HOT9』",@"『电视剧-HOT9』",@"『音乐-HOT9』",@"『鬼畜-HOT9』",@"『娱乐-HOT9』",@"『舞蹈-HOT9』",@"『科技-HOT9』"];
    NSArray *className = @[@"游戏",@"电影",@"番剧",@"动画",@"电视剧",@"音乐",@"鬼畜",@"娱乐",@"舞蹈",@"科技"];
    for (NSInteger index = 0; index < 10; index ++) {
        TenHotVedioView *tenHotVedioView = [[TenHotVedioView alloc] initWithFrame:CGRectMake(0, 20 + SCREEN_HEIGHT / 2.5 + index * (SCREEN_HEIGHT / 2.5 - 10), SCREEN_WIDTH, SCREEN_HEIGHT / 2.5 - 20)];
        //查看跟多按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH - 30 - 33, 5, 40, 20);
        [button setTitle:@"更多" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = 450 + index;
        [button addTarget:self action:@selector(pushToDetailVC:) forControlEvents:UIControlEventTouchUpInside];
        [tenHotVedioView addSubview:button];
        //显示世平介绍图片
        tenHotVedioView.label.text = titleName[index];
        [tenHotVedioView.top1Image sd_setImageWithURL:[NSURL URLWithString:resposeObject[className[index]][0][@"pic"]] forState:UIControlStateNormal];
        [tenHotVedioView.top2Image sd_setImageWithURL:[NSURL URLWithString:resposeObject[className[index]][1][@"pic"]] forState:UIControlStateNormal];
        [tenHotVedioView.top3Image sd_setImageWithURL:[NSURL URLWithString:resposeObject[className[index]][2][@"pic"]] forState:UIControlStateNormal];
        [tenHotVedioView.top4Image sd_setImageWithURL:[NSURL URLWithString:resposeObject[className[index]][3][@"pic"]] forState:UIControlStateNormal];
        tenHotVedioView.top1Text.text = [NSString stringWithFormat:@" %@", resposeObject[className[index]][0][@"title"]];
        tenHotVedioView.top2Text.text = [NSString stringWithFormat:@" %@", resposeObject[className[index]][1][@"title"]];
        tenHotVedioView.top3Text.text = [NSString stringWithFormat:@" %@", resposeObject[className[index]][2][@"title"]];
        tenHotVedioView.top4Text.text = [NSString stringWithFormat:@" %@", resposeObject[className[index]][3][@"title"]];
        //给按钮添加点击事件
        [tenHotVedioView.top1Image addTarget:self action:@selector(hotVideoToPlayer:) forControlEvents:UIControlEventTouchUpInside];
        tenHotVedioView.top1Image.tag = 600 + index;
        
        [tenHotVedioView.top2Image addTarget:self action:@selector(hotVideoToPlayer:) forControlEvents:UIControlEventTouchUpInside];
        tenHotVedioView.top2Image.tag = 610 + index;
        
        [tenHotVedioView.top3Image addTarget:self action:@selector(hotVideoToPlayer:) forControlEvents:UIControlEventTouchUpInside];
        tenHotVedioView.top3Image.tag = 620 + index;
        
        [tenHotVedioView.top4Image addTarget:self action:@selector(hotVideoToPlayer:) forControlEvents:UIControlEventTouchUpInside];
        tenHotVedioView.top4Image.tag = 630 + index;
        [_scrollView addSubview:tenHotVedioView];
    }
}

//按钮功能实现
//进入视屏播放界面
- (void)pushTOVadioPlayerVC:(UIButton *)sender {
    if (_didClip) {
        return;
    }
    _didClip = YES;
    [NetRequest GET:URL_OF_HOME_PAGE parameters:nil success:^(id resposeObject) {
//        NSLog(@"%@",resposeObject[@"result"][@"banners"]);
        NSString *title = resposeObject[@"result"][@"banners"][sender.tag - 500][@"title"];
        //初始化视屏播放界面
        _VedioPlayVC = [[VedioPlayViewController alloc] initWithTitle:title];
        _VedioPlayVC.hidesBottomBarWhenPushed = YES;
        _VedioPlayVC.avNumber = resposeObject[@"result"][@"banners"][sender.tag - 500][@"aid"];
        _VedioPlayVC.videoAddress = resposeObject[@"result"][@"banners"][sender.tag - 500][@"link"];
        [self.navigationController pushViewController:_VedioPlayVC animated:YES];
    } failure:^(NSError *error) {
        UIAlertController *alterController = [UIAlertController alertControllerWithTitle:@"加载失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelItem = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alterController addAction:cancelItem];
        [self presentViewController:alterController animated:YES completion:nil];
        _didClip = NO;
    }];
}
//查看更多按钮
- (void)pushToDetailVC:(UIButton *)sender {
    NSArray *titleName = @[@"『游戏-HOT9』",@"『电影-HOT9』",@"『番剧-HOT9』",@"『动画-HOT9』",@"『电视剧-HOT9』",@"『音乐-HOT9』",@"『鬼畜-HOT9』",@"『娱乐-HOT9』",@"『舞蹈-HOT9』",@"『科技-HOT9』"];
    NSArray *className = @[@"游戏",@"电影",@"番剧",@"动画",@"电视剧",@"音乐",@"鬼畜",@"娱乐",@"舞蹈",@"科技"];
    DetailForTop9ViewController *detailVC = [[DetailForTop9ViewController alloc] initWithTitle:titleName[sender.tag - 450]];
    detailVC.contenst = _getresposeObject[className[sender.tag - 450]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//热门视屏播放
- (void)hotVideoToPlayer:(UIButton *)sender {
    if (_didClip) {
        return;
    }
    _didClip = YES;
    NSArray *className = @[@"游戏",@"电影",@"番剧",@"动画",@"电视剧",@"音乐",@"鬼畜",@"娱乐",@"舞蹈",@"科技"];
    NSLog(@"%@",_getresposeObject[className[(sender.tag - 600) % 10]][(sender.tag - 600) / 10][@"aid"]);
    NSString *title = _getresposeObject[className[(sender.tag - 600) % 10]][(sender.tag - 600) / 10][@"title"];
    //初始化视屏播放界面
    _VedioPlayVC = [[VedioPlayViewController alloc] initWithTitle:title];
    _VedioPlayVC.hidesBottomBarWhenPushed = YES;
    _VedioPlayVC.avNumber = _getresposeObject[className[(sender.tag - 600) % 10]][(sender.tag - 600) / 10][@"aid"];
    [self.navigationController pushViewController:_VedioPlayVC animated:YES];
 
}
//分类选择按钮
- (void)jumpToOppositeLocate:(UIButton *)sender {
    switch (sender.tag - 200) {
        case 0:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 + 1) animated:YES];
            break;
        case 1:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 2 - 10) animated:YES];
            break;
        case 2:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 3 - 20) animated:YES];
            break;
        case 3:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 4 - 30) animated:YES];
            break;
        case 4:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 5 - 40) animated:YES];
            break;
        case 5:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 6 - 50) animated:YES];
            break;
        case 6:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 7 - 60) animated:YES];
            break;
        case 7:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 8 - 70) animated:YES];
            break;
        case 8:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 9 - 90) animated:YES];
            break;
        case 9:
            [_scrollView setContentOffset:CGPointMake(0, SCREEN_HEIGHT / 2.5 * 9 - 90) animated:YES];
            break;
        case 10:
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark --- 代理
//ScrollViewDelegate代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    switch (scrollView.tag - 100) {
        case 1: {
            if (scrollView.contentOffset.y >= SCREEN_HEIGHT / 2.5) {
                [UIView animateWithDuration:0.5 animations:^{
                    _backToTop.frame = CGRectMake(0, 64, SCREEN_WIDTH, 20);
                }];
                
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    _backToTop.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
                }];
            }
            
            if (scrollView.contentOffset.y <= -50) {
                if (self.refresh.tag == 0) {
                    self.refresh.text = @"松开刷新";
                }
                self.refresh.tag = 1;
            }else{
                self.refresh.tag = 0;
                self.refresh.text = @"下拉刷新";
            }
            
        }
            break;
        case 2: {
            NSInteger currentPage = round(scrollView.contentOffset.x / SCREEN_WIDTH);
            _pageControl.currentPage = currentPage - 1;
            if (scrollView.contentOffset.x == 0) {
                _pageControl.currentPage = _numberOfTopViewImage - 1;
            }
            if (scrollView.contentOffset.x == SCREEN_WIDTH * (_numberOfTopViewImage + 1)) {
                _pageControl.currentPage = 0;
            }
            if (scrollView.contentOffset.x < 1) {
                _topScrollView.contentOffset = CGPointMake(SCREEN_WIDTH * _numberOfTopViewImage, 0);
            } else if (scrollView.contentOffset.x > (_numberOfTopViewImage + 1) * SCREEN_WIDTH - 1) {
                [_topScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.tag == 102) {
        [_timerForAutoScorll invalidate];
        _timerForAutoScorll = nil;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.refresh.tag == 1) {
        [UIView animateWithDuration:.3 animations:^{
            self.refresh.text = @"加载中";
            [self loadDataSource];
            scrollView.contentInset = UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.3 animations:^{
                self.refresh.tag = 0;
                self.refresh.text = @"下拉刷新";
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
    if (scrollView.tag == 102) {
        //重新初始化定时器
        _timerForAutoScorll = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoChangeScrollViewPage) userInfo:nil repeats:YES];
    }
}
@end
