//
//  CustomCollectionViewCell.m
//  L16-CollectionView
//
//  Created by rimi on 16/1/19.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //自定义控件
        _titleOfBut = [[UILabel alloc] init];
        _titleOfBut.bounds = CGRectMake(0, 0, 60, 30);
        _titleOfBut.center = CGPointMake(30, 15);
        _titleOfBut.backgroundColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
        _titleOfBut.font = [UIFont systemFontOfSize:14];
        _titleOfBut.textColor = [UIColor whiteColor];
        _titleOfBut.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleOfBut];
        
    }
    return self;
}

@end
