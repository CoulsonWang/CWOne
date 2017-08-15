//
//  ONEHomeNavigationController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeNavigationController.h"
#import "ONENavigationBar.h"

@interface ONEHomeNavigationController ()

@end

@implementation ONEHomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
}

- (void)setUpNavigationBar {
    ONENavigationBar *navBar = [[ONENavigationBar alloc] initWithFrame:CGRectMake(0, 20, CWScreenW, 44)];
    [self setValue:navBar forKeyPath:@"navigationBar"];
}


@end
