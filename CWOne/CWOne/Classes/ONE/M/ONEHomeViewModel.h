//
//  ONEHomeViewModel.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//  视图模型，用来处理原始数据，用于view的显示

#import <Foundation/Foundation.h>

@class ONEHomeItem;

@interface ONEHomeViewModel : NSObject

+ (instancetype)viewModelWithItem:(ONEHomeItem *)homeItem;

@property (strong, nonatomic) ONEHomeItem *homeItem;


// 处理后的属性

// 顶部显示的类型文本
@property (strong, nonatomic) NSString *categoryTitle;

// 作者标签文本
@property (strong, nonatomic) NSString *authorString;

// 时间文本
@property (strong, nonatomic) NSString *timeStr;

// 小记下方的文本
@property (strong, nonatomic) NSString *subTitle;

// 影视下方的副标题
@property (strong, nonatomic) NSString *moviewSubTitle;

@end
