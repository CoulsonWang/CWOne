//
//  ONEHomeNavigationBarTitleView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeWeatherItem;

@interface ONEHomeNavigationBarTitleView : UIView

@property (strong, nonatomic) ONEHomeWeatherItem *weatherItem;

+ (instancetype)homeNavTitleView;

- (void)updateSubFrameAndAlphaWithOffset:(CGFloat)offset;

- (void)enableTheTitleButton:(BOOL)isEnable;

- (void)updateBackButtonVisible:(BOOL)isHidden;

- (void)updateDateStringWithDateString:(NSString *)dateString;

@end
