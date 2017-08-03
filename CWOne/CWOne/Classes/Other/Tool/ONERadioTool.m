//
//  ONERadioTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONERadioTool.h"
#import "ONENetworkTool.h"
#import "ONERadioItem.h"

static ONERadioTool *_instance;

@implementation ONERadioTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ONERadioTool alloc] init];
    });
    return _instance;
}


- (void)loadRadioDataCompletion:(void (^)())completion {
    [[ONENetworkTool sharedInstance] requestRadioStatusDataSuccess:^(NSDictionary *dataDict) {
        self.radioItem = [ONERadioItem radioItemWithDict:dataDict];
        if (completion) {
            completion();
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
