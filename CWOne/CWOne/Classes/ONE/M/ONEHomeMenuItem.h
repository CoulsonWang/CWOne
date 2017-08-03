//
//  ONEHomeMenuItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ONECatalogueItem;

@interface ONEHomeMenuItem : NSObject

+ (instancetype)menuItemWithDict:(NSDictionary *)dict;


// 原始属性
@property (strong, nonatomic) NSString *vol;

@property (strong, nonatomic) NSArray<ONECatalogueItem *> *catelogueItems;


// 自定义属性
@property (strong, nonatomic) NSString *titleString;

@end
