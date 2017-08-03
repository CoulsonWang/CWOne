//
//  ONERadioTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ONERadioItem;

@interface ONERadioTool : NSObject

@property (strong, nonatomic) ONERadioItem *radioItem;

+ (instancetype)sharedInstance;

- (void)loadRadioDataCompletion:(void (^)())completion;

@end
