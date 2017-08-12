//
//  ONEShareTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEShareTool.h"
#import "ONEShareView.h"
#import <SVProgressHUD.h>

static ONEShareTool *_instance;

@interface ONEShareTool () <ONEShareViewDelegate>

@property (weak, nonatomic) ONEShareView *shareView;

@end

@implementation ONEShareTool

- (ONEShareView *)shareView {
    if (!_shareView) {
        ONEShareView *shareView = [[ONEShareView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH)];
        shareView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        _shareView = shareView;
    }
    return _shareView;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ONEShareTool alloc] init];
    });
    return _instance;
}

- (void)showShareViewWithShareUrl:(NSString *)shareUrl {
    self.shareView.shareUrl = shareUrl;
    [self.shareView showShareAnimaton];
}


#pragma mark - ONEShareViewDelegate
- (void)didCopyShareLink:(ONEShareView *)shareView {
    [SVProgressHUD showImage:nil status:@"已复制"];
    [SVProgressHUD dismissWithDelay:1.0];
}
@end
