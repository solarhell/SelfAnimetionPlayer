//
//  TenHotVedioView.h
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/17.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TenHotVedioView : UIView
//显示分类名
@property (nonatomic, strong) UILabel *label;
//显示top4的视屏的信息
@property (nonatomic, strong) UIButton *top1Image;
@property (nonatomic, strong) UILabel *top1Text;

@property (nonatomic, strong) UIButton *top2Image;
@property (nonatomic, strong) UILabel *top2Text;

@property (nonatomic, strong) UIButton *top3Image;
@property (nonatomic, strong) UILabel *top3Text;

@property (nonatomic, strong) UIButton *top4Image;
@property (nonatomic, strong) UILabel *top4Text;

@end
