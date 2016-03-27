//
//  CustomTableViewCell.h
//  表格视图
//
//  Created by Iracle Zhang on 16/1/8.
//  Copyright © 2016年 Iracle Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView *logoImageView;
//标题
@property (nonatomic, strong) UILabel *videoTitle;
//时长
@property (nonatomic, strong) UILabel *duration;
//细分类
@property (nonatomic, strong) UILabel *className;
//上传时间
@property (nonatomic, strong) UILabel *createTime;
@end










