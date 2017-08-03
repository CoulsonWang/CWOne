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
@property (copy, nonatomic) void (^completionHandler)();
@property (strong, nonatomic) NSString *currentMusicUrlString;

@end

@implementation ONERadioTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musciPlayCompletion) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

- (void)playMusicWithUrlString:(NSString *)musicUrlString completion:(void (^)())completion {
    if (!self.player || ![self.currentMusicUrlString isEqualToString:musicUrlString]) {
        NSURL *musciUrl = [NSURL URLWithString:musicUrlString];
        AVPlayer *player = [AVPlayer playerWithURL:musciUrl];
        self.completionHandler = completion;
        self.player = player;
        self.currentMusicUrlString = musicUrlString;
    }
    [self.player play];
}

- (void)playRandomDefaultMusicWithMusicUrls:(NSArray *)musicUrls completion:(void (^)())completion{
    NSInteger random = arc4random_uniform((unsigned int)musicUrls.count);
    NSURL *musicUrl = [NSURL URLWithString:musicUrls[random]];
    AVPlayer *player = [AVPlayer playerWithURL:musicUrl];
    self.completionHandler = completion;
    self.player = player;
    
    [player play];
}

- (void)pauseCurrentMusic {
    [self.player pause];
}

- (void)musciPlayCompletion {
    if (self.completionHandler) {
        self.completionHandler();
    }
}

@end
