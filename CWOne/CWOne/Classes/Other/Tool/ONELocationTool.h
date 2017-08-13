//
//  ONELocationTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONEAuthorizationTool.h"

@interface ONELocationTool : NSObject

+ (instancetype)sharedInstance;

- (void)requestLocationAndGetCityNameWithCompletion:(void (^)(NSString *cityName))completion;

@end
