//
//  ONEHomeHeaderView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeHeaderView.h"
#import "ONEHomeHeadContentView.h"
#import "ONEHomeCatalogueView.h"

@interface ONEHomeHeaderView ()

@property (weak, nonatomic) ONEHomeHeadContentView *headContentView;

@property (weak, nonatomic) ONEHomeCatalogueView *catalogueView;

@end

@implementation ONEHomeHeaderView

#pragma mark - 懒加载
- (ONEHomeHeadContentView *)headContentView {
    if (!_headContentView) {
        ONEHomeHeadContentView *headContentView = [ONEHomeHeadContentView headContentView];
        headContentView.frame = CGRectMake(0, 0, CWScreenW, 0);
        [self addSubview:headContentView];
        _headContentView = headContentView;
    }
    return _headContentView;
}

- (ONEHomeCatalogueView *)catalogueView {
    if (!_catalogueView) {
        ONEHomeCatalogueView *catelogueView = [[ONEHomeCatalogueView alloc] init];
        catelogueView.frame = CGRectMake(0, 0, CWScreenW, 0);
        __weak typeof(self) weakSelf = self;
        catelogueView.updateFrame = ^(BOOL reloadAfterAnimate) {
            if (reloadAfterAnimate) {
                [UIView animateWithDuration:kCatalogueAnimationDuration animations:^{
                    weakSelf.height = CGRectGetMaxY(weakSelf.catalogueView.frame);
                } completion:^(BOOL finished) {
                    if (weakSelf.reload) {
                        weakSelf.reload();
                    }
                }];
            } else {
                if (weakSelf.reload) {
                    weakSelf.reload();
                }
                [UIView animateWithDuration:kCatalogueAnimationDuration animations:^{
                    weakSelf.height = CGRectGetMaxY(weakSelf.catalogueView.frame);
                }];
            }
        };
        [self addSubview:catelogueView];
        _catalogueView = catelogueView;
    }
    return _catalogueView;
}


+ (instancetype)homeHeaderViewWithHeaderViewModel:(ONEHomeViewModel *)viewModel menuItem:(ONEHomeMenuItem *)menuItem {
    ONEHomeHeaderView *headerView = [[ONEHomeHeaderView alloc] init];
    headerView.viewModel = viewModel;
    headerView.menuItem = menuItem;
    
    headerView.frame = CGRectMake(0, 0, CWScreenW, headerView.headerViewHeight);
    
    return headerView;
}

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.headContentView.viewModel = viewModel;
    CGFloat headContentViewHeight = self.headContentView.headContentViewHeight;
    self.headContentView.height = headContentViewHeight;
    self.catalogueView.y = headContentViewHeight;
    [self updateHeight];
}

- (void)setMenuItem:(ONEHomeMenuItem *)menuItem {
    _menuItem = menuItem;
    
    self.catalogueView.menuItem = menuItem;
    CGFloat catalogueViewHeight = self.catalogueView.catalogueHeight;
    self.catalogueView.height = catalogueViewHeight;
    [self updateHeight];
}

- (void)updateHeight {
    self.headerViewHeight = CGRectGetMaxY(self.catalogueView.frame);
    self.height = _headerViewHeight;
}

@end
