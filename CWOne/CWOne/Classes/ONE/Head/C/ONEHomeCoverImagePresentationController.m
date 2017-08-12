//
//  ONEHomeCoverImagePresentatingController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/10.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCoverImagePresentationController.h"

@interface ONEHomeCoverImagePresentationController ()

@end

@implementation ONEHomeCoverImagePresentationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
