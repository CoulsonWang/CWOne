//
//  ONECatalogueItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONECatalogueItem : NSObject

+ (instancetype)catalogueItemWithDict:(NSDictionary *)dict;

@property (strong, nonatomic) NSString *content_type;

@property (strong, nonatomic) NSString *content_id;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSDictionary *tag;


// 自定义属性
@property (strong, nonatomic) NSString *categoryString;

@end
