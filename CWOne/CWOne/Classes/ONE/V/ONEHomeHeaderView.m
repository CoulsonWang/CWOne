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
        [self addSubview:headContentView];
        _headContentView = headContentView;
    }
    return _headContentView;
}

- (ONEHomeCatalogueView *)catalogueView {
    if (!_catalogueView) {
        ONEHomeCatalogueView *catelogueView = [[ONEHomeCatalogueView alloc] init];
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
                [UIView animateWithDuration:kCatalogueAnimationDuration animations:^{
                    weakSelf.height = CGRectGetMaxY(weakSelf.catalogueView.frame);
                }];
                if (weakSelf.reload) {
                    weakSelf.reload();
                }
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
    self.headContentView.frame = CGRectMake(0, 0, CWScreenW, headContentViewHeight);
}

- (void)setMenuItem:(ONEHomeMenuItem *)menuItem {
    _menuItem = menuItem;
    
    self.catalogueView.menuItem = menuItem;
    CGFloat catalogueViewHeight = self.catalogueView.catalogueHeight;
    self.catalogueView.frame = CGRectMake(0, self.headContentView.height, CWScreenW, catalogueViewHeight);
    
    self.headerViewHeight = CGRectGetMaxY(self.catalogueView.frame);
}

@end
