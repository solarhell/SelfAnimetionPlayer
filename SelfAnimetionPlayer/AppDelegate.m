//
//  AppDelegate.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/16.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationController.h"
#import "HomePageViewController.h"
#import "RankingListViewController.h"
#import "NewAnimetiomViewController.h"
#import "MyMassageViewController.h"
#import <AVOSCloud/AVOSCloud.h>

#define APP_ID @"ah2fsaECPfnQusBpxeNaKtFw-gzGzoHsz"
#define APP_KEY @"SRcWsSyH3RoPudFK54CSzKIM"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //显示窗口
    [self.window makeKeyAndVisible];
    //初始化四个被管理的视图控制器
    HomePageViewController *homePage = [[HomePageViewController alloc] init];
    RankingListViewController *rankingListPage = [[RankingListViewController alloc] init];
    NewAnimetiomViewController *newAnimetionPage = [[NewAnimetiomViewController alloc] init];
    MyMassageViewController *myMassagePage = [[MyMassageViewController alloc] init];
    //用代码为视图控制器加入导航控制器
    CustomNavigationController *homePageNav = [[CustomNavigationController alloc] initWithRootViewController:homePage];
    CustomNavigationController *rankingListPageNav = [[CustomNavigationController alloc] initWithRootViewController:rankingListPage];
    CustomNavigationController *newAnimetionPageNav = [[CustomNavigationController alloc] initWithRootViewController:newAnimetionPage];
    CustomNavigationController *myMassagePageNav = [[CustomNavigationController alloc] initWithRootViewController:myMassagePage];
    //初始化标签控制器
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    //设置标签控制器管的视图控制器
    tabBarVC.viewControllers = @[homePageNav, rankingListPageNav, newAnimetionPageNav, myMassagePageNav];
    //设置窗口的根视图控制器为标签控制器
    self.window.rootViewController = tabBarVC;
    
    //把项目和云端服务器连接起来
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
