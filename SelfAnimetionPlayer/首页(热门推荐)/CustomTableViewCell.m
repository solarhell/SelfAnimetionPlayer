//
//  CustomTableViewCell.m
//  表格视图
//
//  Created by Iracle Zhang on 16/1/8.
//  Copyright © 2016年 Iracle Zhang. All rights reserved.
//

#import "CustomTableViewCell.h"
#define WIDTH_OF_SCREEN [UIScreen mainScreen].bounds.size.width

@implementation CustomTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载控件
        [self initInterface];
    }
    return self;
}

- (void)initInterface {
    //加载一个背景label
    UILabel *labelForBG = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, WIDTH_OF_SCREEN - 10, 110)];
    labelForBG.layer.cornerRadius = 15;
    labelForBG.clipsToBounds = YES;
    labelForBG.layer.borderColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0].CGColor;
    labelForBG.layer.borderWidth = 1;
    labelForBG.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:labelForBG];
    //加载头像
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 120, 100)];
    _logoImageView.layer.cornerRadius = 10;
    _logoImageView.clipsToBounds = YES;
    [labelForBG addSubview:_logoImageView];
    
    //标题
    _videoTitle = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, WIDTH_OF_SCREEN - 140 - 10 - 10, 20)];
    _videoTitle.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14];
    [labelForBG addSubview:_videoTitle];
    //时长
    _duration = [[UILabel alloc] initWithFrame:CGRectMake(140, 10 + 20, WIDTH_OF_SCREEN - 140 - 10 - 10, 20)];
    _duration.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    _duration.textColor = [UIColor grayColor];
    [labelForBG addSubview:_duration];
    //细分类
    _className = [[UILabel alloc] initWithFrame:CGRectMake(140, 10 + 20 + 20, WIDTH_OF_SCREEN - 140 - 10 - 10, 20)];
    _className.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [labelForBG addSubview:_className];
    //上传时间
    _createTime = [[UILabel alloc] initWithFrame:CGRectMake(140, 110 - 20, WIDTH_OF_SCREEN - 140 - 10 - 10, 20)];
    _createTime.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    _createTime.textColor = [UIColor grayColor];
    [labelForBG addSubview:_createTime];
}

@end










