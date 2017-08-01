//
//  ONENetworkTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONENetworkTool.h"
#import <AFNetworking.h>

static ONENetworkTool *_instance;
@implementation ONENetworkTool

// 单例
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ONENetworkTool alloc] init];
    });
    return _instance;
}

- (void)requestHomeDataWithDate:(NSString *)date success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    NSString *requestURL;
    if (date == nil) {
        requestURL = @"http://v3.wufazhuce.com:8000/api/channel/one/0/0";
    } else {
        requestURL = [NSString stringWithFormat:@"http://v3.wufazhuce.com:8000/api/channel/one/%@/0",date];
    }
    
    
    [[AFHTTPSessionManager manager] GET:requestURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        NSDictionary *dataDict = responseObject[@"data"];
        success(dataDict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end
