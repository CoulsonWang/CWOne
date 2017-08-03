//
//  ONENetworkTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONENetworkTool : NSObject

+ (instancetype)sharedInstance;

// 请求主页数据
- (void)requestHomeDataWithDate:(NSString *)date success:(void (^)(NSDictionary *dataDict))success failure:(void (^)(NSError *error))failure;

// 发送POST请求通知服务器某一条已点赞
- (void)postPraisedWithItemId:(NSString *)item_id success:(void (^)())success failure:(void (^)(NSError *error))failure;

// 获取当前电台状态数据
- (void)requestRadioStatusDataSuccess:(void (^)(NSDictionary *dataDict))success failure:(void (^)(NSError *error))failure;

@end
