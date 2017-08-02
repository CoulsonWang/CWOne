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

+ (instancetype)homeNavTitleView;

@property (strong, nonatomic) ONEHomeWeatherItem *weatherItem;

@end
