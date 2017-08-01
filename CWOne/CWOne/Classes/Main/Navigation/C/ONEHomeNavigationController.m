//
//  ONEHomeNavigationController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeNavigationController.h"
#import "UIImage+CWColorAndStretch.h"

@interface ONEHomeNavigationController ()

@end

@implementation ONEHomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:254/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
