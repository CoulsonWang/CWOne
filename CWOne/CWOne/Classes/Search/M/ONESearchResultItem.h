//
//  ONESearchResultItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/14.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONESearchResultItem : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *subtitle;

@property (strong, nonatomic) NSString *cover;

@property (assign, nonatomic) NSInteger category;

@property (assign, nonatomic) NSInteger content_id;

+ (instancetype)searchResultItemWihtDict:(NSDictionary *)dict;



@end
