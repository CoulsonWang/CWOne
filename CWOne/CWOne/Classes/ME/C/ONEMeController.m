//
//  ONEMeController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEMeController.h"
#import "ONELoginTool.h"
#import "ONENavigationBarTool.h"
#import "UIImage+CWColorAndStretch.h"
#import "ONESettingTableViewController.h"
#import "ONENavigationBarTool.h"

@interface ONEMeController ()

@property (weak, nonatomic) IBOutlet UIButton *imageCoverButton;
@end

@implementation ONEMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageCoverButton.layer.cornerRadius = self.imageCoverButton.width * 0.5;
    self.imageCoverButton.layer.masksToBounds = YES;
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 状态栏动画
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[ONENavigationBarTool sharedInstance] updateCurrentViewController:self];
    [[ONENavigationBarTool sharedInstance] changeNavigationBarToLucencyMode];
    [[ONENavigationBarTool sharedInstance] changeNavigationBarTintColor:ONENavigationBarTintColorWhite];
    [[ONENavigationBarTool sharedInstance] hideStatusBarWithAnimated:NO];
    [[ONENavigationBarTool sharedInstance] resumeStatusBarWithAnimated:YES];
}

- (IBAction)coverButtonClick:(UIButton *)sender {
    [self showLoginView];
}
- (IBAction)coverTitleButtonClick:(UIButton *)sender {
    [self showLoginView];
}

#pragma mark - 私有方法
- (void)showLoginView {
    [[ONELoginTool sharedInstance] showLoginView];
}

@end
