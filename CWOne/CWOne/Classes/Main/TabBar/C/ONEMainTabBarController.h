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

// 从网络请求到的数据，暂时先保存在这个控制器，后续使用CoreData进行存储

@property (strong, nonatomic) NSArray<ONEHomeItem *> *homeItems;

@property (strong, nonatomic) ONEHomeWeatherItem *weatherItem;

@end
