//
//  CWImageView.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "CWImageView.h"

@interface CWImageView ()

@property (weak,nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation CWImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setOperation:(void (^)())operation {
    _operation = operation;
    // 先移除旧的手势
    [self removeGestureRecognizer:self.tapGesture];
    // 添加新手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTapped)];
    [self addGestureRecognizer:tap];
    self.tapGesture = tap;
}

- (void)viewDidTapped {
    if (self.operation != nil) {
        self.operation();
    }
    
}

@end
