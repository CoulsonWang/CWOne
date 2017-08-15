//
//  ONEAllSpecialTableViewCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/15.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllSpecialTableViewCell.h"
#import "ONESpecialItem.h"
#import <UIImageView+WebCache.h>
#import "UILabel+CWLineSpacing.h"

#define kSpecialTagViewSize 50.0
#define kTagLabelHeigth 20.0

@interface ONEAllSpecialTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ONEAllSpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.infoLabel.font = [UIFont systemFontOfSize:16.0 weight:-0.1];
    
    // 给图片左上角添加标签
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(self.coverImageView.x, self.coverImageView.y, kSpecialTagViewSize, kSpecialTagViewSize)];
    tagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.contentView addSubview:tagView];
    
    // 进行三角形裁剪
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(0, kSpecialTagViewSize)];
    [path addLineToPoint:CGPointMake(kSpecialTagViewSize, 0)];
    [path closePath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = tagView.layer.bounds;
    maskLayer.path = path.CGPath;
    [tagView.layer addSublayer:maskLayer];
    tagView.layer.mask = maskLayer;
    
    // 添加文本标签
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.layer.anchorPoint = CGPointMake(0, 1);
    tagLabel.frame = CGRectMake(0, kSpecialTagViewSize - kTagLabelHeigth, kSpecialTagViewSize * sqrt(2.0), kTagLabelHeigth);
    tagLabel.text = @"专题";
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.font = [UIFont systemFontOfSize:11];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [tagView addSubview:tagLabel];
}


- (void)setSpecialItem:(ONESpecialItem *)specialItem {
    NSURL *coverURL = [NSURL URLWithString:specialItem.cover];
    [self.coverImageView sd_setImageWithURL:coverURL];
    
    [self.infoLabel setText:specialItem.title lineSpacing:10.0];
    self.infoLabel.text = specialItem.title;
}

@end
