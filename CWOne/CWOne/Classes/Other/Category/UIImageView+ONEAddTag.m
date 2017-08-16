//
//  UIImageView+ONEAddTag.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "UIImageView+ONEAddTag.h"

#define kTagSize 50.0
#define kTagLabelHeigth 20.0

@implementation UIImageView (ONEAddTag)

- (void)addTagViewWithTagText:(NSString *)tagText {
    // 给图片左上角添加标签
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(self.x, self.y, kTagSize, kTagSize)];
    tagView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.superview addSubview:tagView];
    
    // 进行三角形裁剪
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(0, kTagSize)];
    [path addLineToPoint:CGPointMake(kTagSize, 0)];
    [path closePath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = tagView.layer.bounds;
    maskLayer.path = path.CGPath;
    [tagView.layer addSublayer:maskLayer];
    tagView.layer.mask = maskLayer;
    
    // 添加文本标签
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.layer.anchorPoint = CGPointMake(0, 1);
    tagLabel.frame = CGRectMake(0, kTagSize - kTagLabelHeigth, kTagSize * sqrt(2.0), kTagLabelHeigth);
    tagLabel.text = tagText;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.font = [UIFont systemFontOfSize:11];
    tagLabel.textColor = [UIColor whiteColor];
    tagLabel.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [tagView addSubview:tagLabel];
}

@end
