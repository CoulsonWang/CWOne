//
//  ONESpecialItem.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/15.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONESpecialItem : NSObject

@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *cover;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger category;
@property (strong, nonatomic) NSString *content_id;
@property (assign, nonatomic) BOOL is_stick;
@property (strong, nonatomic) NSArray *serial_list;
@property (strong, nonatomic) NSString *font_color;
@property (strong, nonatomic) NSString *bg_color;

+ (instancetype)specialItemWithDict:(NSDictionary *)dict;

@end
