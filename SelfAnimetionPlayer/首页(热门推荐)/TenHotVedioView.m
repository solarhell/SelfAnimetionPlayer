//
//  TenHotVedioView.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/17.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "TenHotVedioView.h"
#define WIDTH_OF_SCREEN [UIScreen mainScreen].bounds.size.width
#define HEIGHT_OF_SCREEN [UIScreen mainScreen].bounds.size.height

@implementation TenHotVedioView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

//加载控件
- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    //标签
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 30)];
    _label.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    _label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
    //进入更多图标
    UIImageView *forMoreMassage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 32, 10, 10, 10)];
    forMoreMassage.image = [UIImage imageNamed:@"right"];
    [self addSubview:forMoreMassage];
    //top4视屏信息
    _top1Image = [UIButton buttonWithType:UIButtonTypeCustom];
    _top1Image.frame = CGRectMake(10, 35, WIDTH_OF_SCREEN / 2 - 20, HEIGHT_OF_SCREEN / 6 - 15);
    _top1Image.backgroundColor = [UIColor colorWithRed:0.8438 green:0.8394 blue:0.8482 alpha:0.5];
    _top1Image.layer.borderWidth = 1;
    _top1Image.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _top1Image.layer.cornerRadius = 8;
    _top1Image.clipsToBounds = YES;
    _top1Image.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_top1Image];
    _top1Text = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_OF_SCREEN / 6 - 15 - 15, WIDTH_OF_SCREEN / 2 - 20, 15)];
    _top1Text.backgroundColor = [UIColor colorWithRed:0.8245 green:0.7953 blue:0.8183 alpha:0.8];
    _top1Text.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_top1Image addSubview:_top1Text];
    
    _top2Image = [UIButton buttonWithType:UIButtonTypeCustom];
    _top2Image.frame = CGRectMake(10 + WIDTH_OF_SCREEN / 2, 35, WIDTH_OF_SCREEN / 2 - 20, HEIGHT_OF_SCREEN / 6 - 15);
    _top2Image.backgroundColor = [UIColor colorWithRed:0.8438 green:0.8394 blue:0.8482 alpha:0.5];
    _top2Image.layer.borderWidth = 1;
    _top2Image.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _top2Image.layer.cornerRadius = 8;
    _top2Image.clipsToBounds = YES;
    _top2Image.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_top2Image];
    _top2Text = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_OF_SCREEN / 6 - 15 - 15, WIDTH_OF_SCREEN / 2 - 20, 15)];
    _top2Text.backgroundColor = [UIColor colorWithRed:0.8245 green:0.7953 blue:0.8183 alpha:0.8];
    _top2Text.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_top2Image addSubview:_top2Text];
    
    _top3Image = [UIButton buttonWithType:UIButtonTypeCustom];
    _top3Image.frame = CGRectMake(10, 50 + HEIGHT_OF_SCREEN / 6 - 22, WIDTH_OF_SCREEN / 2 - 20, HEIGHT_OF_SCREEN / 6 - 15);
    _top3Image.backgroundColor = [UIColor colorWithRed:0.8438 green:0.8394 blue:0.8482 alpha:0.5];
    _top3Image.layer.borderWidth = 1;
    _top3Image.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _top3Image.layer.cornerRadius = 8;
    _top3Image.clipsToBounds = YES;
    _top3Image.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_top3Image];
    _top3Text = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_OF_SCREEN / 6 - 15 - 15, WIDTH_OF_SCREEN / 2 - 20, 15)];
    _top3Text.backgroundColor = [UIColor colorWithRed:0.8245 green:0.7953 blue:0.8183 alpha:0.8];
    _top3Text.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_top3Image addSubview:_top3Text];
    
    _top4Image = [UIButton buttonWithType:UIButtonTypeCustom];
    _top4Image.frame = CGRectMake(10 + WIDTH_OF_SCREEN / 2, 50 + HEIGHT_OF_SCREEN / 6 - 22, WIDTH_OF_SCREEN / 2 - 20, HEIGHT_OF_SCREEN / 6 - 15);
    _top4Image.backgroundColor = [UIColor colorWithRed:0.8438 green:0.8394 blue:0.8482 alpha:0.5];
    _top4Image.layer.borderWidth = 1;
    _top4Image.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    _top4Image.layer.cornerRadius = 8;
    _top4Image.clipsToBounds = YES;
    _top4Image.imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_top4Image];
    _top4Text = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_OF_SCREEN / 6 - 15 - 15, WIDTH_OF_SCREEN / 2 - 20, 15)];
    _top4Text.backgroundColor = [UIColor colorWithRed:0.8245 green:0.7953 blue:0.8183 alpha:0.8];
    _top4Text.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [_top4Image addSubview:_top4Text];
    
}

@end
