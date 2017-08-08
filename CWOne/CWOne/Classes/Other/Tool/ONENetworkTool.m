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
    
    NSDictionary *parameters = @{
                                 @"version":@"v4.3.0",
                                 };
    
    [[AFHTTPSessionManager manager] GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dataDict = responseObject[@"data"];
            if (dataDict) {
                success(dataDict);
            } else {
                NSError *error = [NSError errorWithDomain:@"请求的日期有误" code:250 userInfo:nil];
                failure(error);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postPraisedWithItemId:(NSString *)item_id success:(void (^)())success failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = @{};
    
    [[AFHTTPSessionManager manager] POST:@"" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postPraisedCommentWithType:(NSString *)typeName itemId:(NSString *)item_id commentId:(NSString *)commentId success:(void (^)())success failure:(void (^)(NSError *))failure {
    NSString *postURL = @"http://v3.wufazhuce.com:8000/api/comment/praise";
    NSDictionary *parameters = @{
                                 @"cmtid":commentId,
                                 @"itemid":item_id,
                                 @"type":typeName,
                                 };
    [[AFHTTPSessionManager manager] POST:postURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postUnpraisedCommentWithType:(NSString *)typeName item_id:(NSString *)item_id commentId:(NSString *)commentId success:(void (^)())success failure:(void (^)(NSError *))failure {
    NSString *postURL = @"http://v3.wufazhuce.com:8000/api/comment/unpraise";
    NSDictionary *parameters = @{
                                 @"cmtid":commentId,
                                 @"itemid":item_id,
                                 @"type":typeName,
                                 };
    [[AFHTTPSessionManager manager] POST:postURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestRadioStatusDataSuccess:(void (^)(NSDictionary *dataDict))success failure:(void (^)(NSError *))failure {
    NSString *requestURL = @"http://v3.wufazhuce.com:8000/api/radio/active";
    NSDictionary *parameters = @{};
    
    [[AFHTTPSessionManager manager] GET:requestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dataDict = responseObject[@"data"];
            success(dataDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestDetailDataOfType:(NSString *)typeName withItemId:(NSString *)item_id success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    if ([typeName isEqualToString:@"serial"]) {
        typeName = @"serialcontent";
    }
    NSString *requestURL = [NSString stringWithFormat:@"http://v3.wufazhuce.com:8000/api/%@/htmlcontent/%@",typeName,item_id];
    
    NSDictionary *parameters = @{
                                 @"version":@"v4.3.0",
                                 };
    
    [[AFHTTPSessionManager manager] GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dataDict = responseObject[@"data"];
            success(dataDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestCommentListOfType:(NSString *)typeName WithItemID:(NSString *)item_id lastID:(NSString *)lastID success:(void (^)(NSArray<NSDictionary *> *))success failure:(void (^)(NSError *))failure {
    NSString *lastCommentId = (lastID == nil) ? @"0" : lastID;
    NSString *requestURL = [NSString stringWithFormat:@"http://v3.wufazhuce.com:8000/api/comment/praiseandtime/%@/%@/%@",typeName, item_id,lastCommentId];
    NSDictionary *parameters = @{
                                 @"version":@"v4.3.0",
                                 };
    
    [[AFHTTPSessionManager manager] GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dataDict = responseObject[@"data"];
            NSArray *dataArray = dataDict[@"data"];
            success(dataArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

- (void)requestRelatedListDataOfType:(NSString *)typeName withItemId:(NSString *)item_id success:(void (^)(NSArray<NSDictionary *> *))success failure:(void (^)(NSError *))failure {
    NSString *requestURL = [NSString stringWithFormat:@"http://v3.wufazhuce.com:8000/api/relatedforwebview/%@/%@",typeName,item_id];
    NSDictionary *parameters = @{
                                 @"version":@"v4.3.0",
                                 };
    
    [[AFHTTPSessionManager manager] GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if (success) {
            NSArray *dataArray = responseObject[@"data"];
            success(dataArray);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestMusicDetailDataWithItemId:(NSString *)item_id success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    NSString *requestURL = [NSString stringWithFormat:@"http://v3.wufazhuce.com:8000/api/music/detail/%@",item_id];
    
    NSDictionary *parameters = @{
                                 @"version":@"v4.3.0",
                                 };
    
    [[AFHTTPSessionManager manager] GET:requestURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dataDict = responseObject[@"data"];
            success(dataDict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
