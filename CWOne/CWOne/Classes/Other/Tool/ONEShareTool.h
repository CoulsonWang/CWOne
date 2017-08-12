//
//  ONEShareTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEShareTool : NSObject

+ (instancetype)sharedInstance;

- (void)showShareViewWithShareUrl:(NSString *)shareUrl;

@end
