//
//  ONEAuthorInfoController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAuthorInfoController.h"
#import "ONENavigationBarTool.h"

@interface ONEAuthorInfoController ()

@end

@implementation ONEAuthorInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [self loadData];
}

- (void)setUpNavigationBar {
    [[ONENavigationBarTool sharedInstance] changeShadowViewVisible:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_default"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarBackButtonClick)];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)loadData {
    
}

#pragma mark - 事件响应
- (void)navigationBarBackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
