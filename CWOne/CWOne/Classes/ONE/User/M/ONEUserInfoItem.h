//
//  ONEUserInfoItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEUserInfoItem : NSObject


@property (strong, nonatomic) NSString *web_url;

@property (strong, nonatomic) NSString *user_name;

@property (strong, nonatomic) NSString *background;

@property (strong, nonatomic) NSArray<NSString *> *followList;

+ (instancetype)userInfoItemWithDict:(NSDictionary *)dict;

@end
