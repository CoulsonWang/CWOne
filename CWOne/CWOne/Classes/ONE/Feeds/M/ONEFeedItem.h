//
//  ONEFeedItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEFeedItem : NSObject

+ (instancetype)feedItemWithDict:(NSDictionary *)dict;

@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *cover;

@end
