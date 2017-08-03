//
//  ONEHomeCatalogueView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCatalogueView.h"
#import "ONEHomeMenuItem.h"
#import "ONECatalogueItem.h"

#define kTitleButtonHeight 40.0
#define kTitleButtonLabelWidth 100.0
#define kSeperateViewHeight 6.0
#define kCatalogueViewOriginHeight kTitleButtonHeight + kSeperateViewHeight

@interface ONEHomeCatalogueView ()

@property (weak, nonatomic) UIButton *titleButton;

@property (weak, nonatomic) UIImageView *arrowView;

@property (weak, nonatomic) UITableView *listView;

@property (strong, nonatomic) NSArray<ONECatalogueItem *> *cataLogueItems;

@property (weak, nonatomic) UIView *seperateView;

@end

@implementation ONEHomeCatalogueView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self arrowView];
        
    }
    return self;
}

#pragma mark - 懒加载
- (UIButton *)titleButton {
    if (!_titleButton) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(0, 0, CWScreenW, kTitleButtonHeight);
        [titleButton setTitleColor:[UIColor colorWithWhite:122/255.0 alpha:1.0] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:titleButton];
        _titleButton = titleButton;
    }
    return _titleButton;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
        [arrowView sizeToFit];
        arrowView.centerY = self.titleButton.centerY;
        arrowView.x = CWScreenW * 0.5 + kTitleButtonLabelWidth * 0.5;
        [self addSubview:arrowView];
        _arrowView = arrowView;
    }
    return _arrowView;
}

- (UIView *)seperateView {
    if (!_seperateView) {
        UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.catalogueHeight - kSeperateViewHeight, CWScreenW, kSeperateViewHeight)];
        seperateView.backgroundColor = ONEBackgroundColor;
        [self addSubview:seperateView];
        _seperateView = seperateView;
    }
    return _seperateView;
}

- (void)setMenuItem:(ONEHomeMenuItem *)menuItem {
    _menuItem = menuItem;
    
    self.cataLogueItems = menuItem.catelogueItems;
    
    self.catalogueHeight = kCatalogueViewOriginHeight;
    
    [self.titleButton setTitle:menuItem.titleString forState:UIControlStateNormal];
    [self seperateView];
}

#pragma mark - 事件响应
- (void)titleButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [self changeArrowViewOrientationToUp:sender.isSelected];
    // 展开或收起
}

// 箭头方向变化
- (void)changeArrowViewOrientationToUp:(BOOL)isUp {

    self.arrowView.transform = isUp ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    
}

@end
