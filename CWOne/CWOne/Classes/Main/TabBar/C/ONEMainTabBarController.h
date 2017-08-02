//
//  ONEMainTabBarController.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeItem;

@class ONEHomeWeatherItem;

@interface ONEMainTabBarController : UITabBarController

@property (strong, nonatomic) NSArray<ONEHomeItem *> *homeItems;

@property (strong, nonatomic) ONEHomeWeatherItem *weatherItem;

@end
