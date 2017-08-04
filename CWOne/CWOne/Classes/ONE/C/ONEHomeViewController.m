//
//  ONEHomeViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/4.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeViewController.h"
#import "ONEHomeTableViewController.h"
#import "ONEDateTool.h"
#import "ONEMainTabBarController.h"
#import "ONEHomeNavigationController.h"

#define kChangePageAnimateDuration 0.3

typedef enum : NSUInteger {
    ONESrollDiretionLeft,
    ONESrollDiretionRight,
} ONESrollDiretion;

@interface ONEHomeViewController () <UIScrollViewDelegate, ONEHomeTableViewControllerDelegate>

@property (weak, nonatomic) UIScrollView *scrollView;

@property (weak, nonatomic) ONEHomeTableViewController *leftVC;
@property (weak, nonatomic) ONEHomeTableViewController *middleVC;
@property (weak, nonatomic) ONEHomeTableViewController *rightVC;

@property (weak, nonatomic) UITableView *leftTableView;
@property (weak, nonatomic) UITableView *middleTableView;
@property (weak, nonatomic) UITableView *rightTableView;

@property (weak, nonatomic) ONEHomeTableViewController *currentVC;
@property (assign, nonatomic) NSInteger lastIndex;

@end

@implementation ONEHomeViewController
#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH)];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (ONEHomeTableViewController *)leftVC {
    if (!_leftVC) {
        ONEHomeTableViewController *leftTableVC = [[ONEHomeTableViewController alloc] init];
        leftTableVC.delegate = self;
        self.leftVC = leftTableVC;
        [self addChildViewController:leftTableVC];
        _leftVC = leftTableVC;
    }
    return _leftVC;
}
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        UITableView *leftTableView = self.leftVC.tableView;
        leftTableView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
        [self.scrollView addSubview:leftTableView];
        _leftTableView = leftTableView;
    }
    return _leftTableView;
}
- (ONEHomeTableViewController *)middleVC {
    if (!_middleVC) {
        ONEHomeTableViewController *middleTableVC = [[ONEHomeTableViewController alloc] init];
        middleTableVC.delegate = self;
        self.middleVC = middleTableVC;
        [self addChildViewController:middleTableVC];
        _middleVC = middleTableVC;
    }
    return _middleVC;
}
- (UITableView *)middleTableView {
    if (!_middleTableView) {
        UITableView *middleTableView = self.middleVC.tableView;
        middleTableView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
        [self.scrollView addSubview:middleTableView];
        _middleTableView = middleTableView;
    }
    return _middleTableView;
}
- (ONEHomeTableViewController *)rightVC {
    if (!_rightVC) {
        ONEHomeTableViewController *rightTableVC = [[ONEHomeTableViewController alloc] init];
        rightTableVC.delegate = self;
        self.rightVC = rightTableVC;
        [self addChildViewController:rightTableVC];
        _rightVC = rightTableVC;
    }
    return _rightVC;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        UITableView *rightTableView = self.rightVC.tableView;
        rightTableView.frame = CGRectMake(0, 0, CWScreenW, CWScreenH);
        [self.scrollView addSubview:rightTableView];
        _rightTableView = rightTableView;
    }
    return _rightTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpScrollView];
    
    self.lastIndex = 0;
    self.currentVC = self.middleVC;
    
    self.leftTableView.x = CWScreenW * 2;
    
    self.middleTableView.x = 0;
    self.middleVC.dateStr = kCurrentDateString;
    
    self.rightTableView.x = CWScreenW;
    self.rightVC.dateStr = [[ONEDateTool sharedInstance] yesterdayDateStr];
    
}



#pragma mark - 初始化控件
- (void)setUpScrollView {
    UIScrollView *scrollV = self.scrollView;
    scrollV.contentSize = CGSizeMake(MAXFLOAT, 0);
    scrollV.backgroundColor = [UIColor colorWithR:239 G:239 B:243];
    scrollV.pagingEnabled = YES;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.contentOffset = CGPointMake(0, 0);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    scrollV.delegate = self;
}

#pragma mark - 私有工具方法
// 确定哪个控制器需要移动
- (ONEHomeTableViewController *)getTheControllerNeedToMoveWithDirection:(ONESrollDiretion)direction {
    if (self.currentVC == self.middleVC) {
        if (direction == ONESrollDiretionLeft) {
            return self.rightVC;
        } else {
            return self.leftVC;
        }
    } else if (self.currentVC == self.leftVC) {
        if (direction == ONESrollDiretionLeft) {
            return self.middleVC;
        } else {
            return self.rightVC;
        }
    } else {
        if (direction == ONESrollDiretionLeft) {
            return self.leftVC;
        } else {
            return self.middleVC;
        }
    }
}
// 更新当前的控制器
- (void)updateCurrentVCWithDirection:(ONESrollDiretion)direction {
    if (self.currentVC == self.middleVC) {
        if (direction == ONESrollDiretionLeft) {
            self.currentVC = self.leftVC;
        } else {
            self.currentVC = self.rightVC;
        }
    } else if (self.currentVC == self.leftVC) {
        if (direction == ONESrollDiretionLeft) {
            self.currentVC = self.rightVC;
        } else {
            self.currentVC = self.middleVC;
        }
    } else {
        if (direction == ONESrollDiretionLeft) {
            self.currentVC = self.middleVC;
        } else {
            self.currentVC = self.leftVC;
        }
    }
}

- (void)singleMoveWithDirection:(ONESrollDiretion)direction toIndex:(NSInteger)index{
    ONEHomeTableViewController *moveVC = [self getTheControllerNeedToMoveWithDirection:direction];
    NSInteger newIndex = (direction == ONESrollDiretionRight) ? index + 1 : index - 1;
    moveVC.dateStr = [[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:newIndex];
    moveVC.tableView.x = newIndex * CWScreenW;
    self.lastIndex = index;
    [self updateCurrentVCWithDirection:direction];
}

- (void)refreshTitleViewWithOffset:(CGFloat)offset {
    ONEMainTabBarController *tabVC = (ONEMainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    ONEHomeNavigationController *navVC = tabVC.viewControllers.firstObject;
    [navVC confirmTitlViewWithOffset:0];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / CWScreenW;
    
    // 仅移动了一页时的处理
    if (index == _lastIndex + 1) {
        [self singleMoveWithDirection:ONESrollDiretionRight toIndex:index];
    } else if (index == _lastIndex - 1) {
        if (index != 0) {
            [self singleMoveWithDirection:ONESrollDiretionLeft toIndex:index];
        }
    } else if (index == _lastIndex) {
        return;
    } else {
        // 移动了大于一页时的处理,更新三个tableView的位置和数据
        [self.middleVC setDateStr:[[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:index] withCompletion:^{
            self.middleTableView.x = index * CWScreenW;
        }];
        [self.rightVC setDateStr:[[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:index + 1] withCompletion:^{
            self.rightTableView.x = (index + 1) * CWScreenW;
        }];
        if (index != 0) {
            [self.leftVC setDateStr:[[ONEDateTool sharedInstance] getDateStringFromCurrentDateWihtDateInterval:index - 1] withCompletion:^{
                self.leftTableView.x = (index - 1) * CWScreenW;
            }];
        }
        self.lastIndex = index;
        self.currentVC = self.middleVC;
    }
    [self refreshTitleViewWithOffset:self.currentVC.tableView.contentOffset.y];

}

#pragma mark - ONEHomeTableViewControllerDelegate
- (void)homeTableViewFooterButtonClick:(ONEHomeTableViewController *)homeTableViewController {
    CGFloat currentOffsetX = self.scrollView.contentOffset.x;
    [UIView animateWithDuration:kChangePageAnimateDuration animations:^{
        self.scrollView.contentOffset = CGPointMake(currentOffsetX + CWScreenW, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
    
}

@end
