//
//  VedioPlayViewController.h
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/17.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VedioPlayViewController : UIViewController
//获取视屏的av号
@property (nonatomic, strong) NSString *avNumber;
//获取视频所在网址
@property (nonatomic, strong) NSString *videoAddress;

- (instancetype)initWithTitle:(NSString *)title;

@end
