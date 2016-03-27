//
//  NewVideosCustomCollectionViewCell.m
//  SelfAnimetionPlayer
//
//  Created by rimi on 16/1/21.
//  Copyright © 2016年 ChenZongYuan. All rights reserved.
//

#import "NewVideosCustomCollectionViewCell.h"

@implementation NewVideosCustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //自定义控件
        [self loadviews];
    }
    return self;
}

- (void)loadviews {
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor colorWithRed:0.3862 green:0.7749 blue:0.4809 alpha:1.0];
    [self addSubview:_label];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.layer.cornerRadius = 5;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
    [self addSubview:_titleLabel];
    
    _createTimeLabel = [[UILabel alloc] init];
    _createTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:10];
    [self addSubview:_createTimeLabel];
    
}
@end
