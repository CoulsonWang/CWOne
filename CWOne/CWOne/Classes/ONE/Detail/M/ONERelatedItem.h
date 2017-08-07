//
//  ONERelatedItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/7.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ONEUserItem;

@interface ONERelatedItem : NSObject

@property (strong, nonatomic) ONEUserItem *author;

@property (assign, nonatomic) NSInteger category;

@property (strong, nonatomic) NSString *title;

+ (instancetype)relatedItemWithDict:(NSDictionary *)dict;

@end
