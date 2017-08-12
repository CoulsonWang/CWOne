//
//  ONELoginTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONELoginTool : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isLogin;

- (void)showLoginView;

@end
