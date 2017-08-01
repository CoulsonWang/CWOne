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

- (void)requestHomeDataWithDate:(NSString *)date success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

@end
