//
//  ONEHomeHeaderView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeViewModel;
@class ONEHomeMenuItem;

@interface ONEHomeHeaderView : UIView

+ (instancetype)homeHeaderViewWithHeaderViewModel:(ONEHomeViewModel *)viewModel menuItem:(ONEHomeMenuItem *)menuItem;

@property (strong, nonatomic) ONEHomeViewModel *viewModel;

@property (strong, nonatomic) ONEHomeMenuItem *menuItem;

@property (assign, nonatomic) CGFloat headerViewHeight;

@property (copy, nonatomic) void(^reload)();

@end
