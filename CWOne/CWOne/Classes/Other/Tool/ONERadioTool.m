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
#import <AVFoundation/AVFoundation.h>

static ONERadioTool *_instance;

@interface ONERadioTool ()

@property (strong, nonatomic) AVPlayer *player;

@end

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

- (void)playDefaultMusicWithMusicUrls:(NSArray *)musicUrls {
    NSInteger random = arc4random_uniform((unsigned int)musicUrls.count);
    NSURL *musicUrl = [NSURL URLWithString:musicUrls[random]];
    AVPlayer *player = [AVPlayer playerWithURL:musicUrl];
    self.player = player;
    
    [player play];
}

- (void)stopCurrentMusic {
    [self.player pause];
    self.player = nil;
}

@end
