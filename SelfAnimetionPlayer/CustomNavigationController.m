//
//  CustomNavigationController.m
//  Test_1_8
//  改变标题栏颜色
//  Created by rimi on 16/1/8.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
