//
//  ONEHomeNavigationController.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEHomeNavigationController : UINavigationController

- (void)updateTitleViewWithOffset:(CGFloat)offset;

// 确定title的状态
- (void)confirmTitlViewWithOffset:(CGFloat)offset;

- (void)updateTitleViewBackToTodayButtonVisible:(BOOL)isHidden;

- (void)updateTitleViewDateStringWithDateString:(NSString *)dateString;

- (void)hideCustomTitleView;

- (void)showCustomTitleViewWithOffset:(CGFloat)offset;

@end
