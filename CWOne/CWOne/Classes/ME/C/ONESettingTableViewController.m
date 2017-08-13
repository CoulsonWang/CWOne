//
//  ONESettingTableViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESettingTableViewController.h"
#import "UIImage+CWColorAndStretch.h"
#import "UIImage+Render.h"
#import "ONENetworkTool.h"
#import <UIImageView+WebCache.h>

@interface ONESettingTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *recAppCell;

@end

@implementation ONESettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recAppCell.imageView.bounds = CGRectMake(0, 0, 30, 30);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(popVC)];
    self.title = @"设置";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    [[ONENetworkTool sharedInstance] requestRecAppListSuccess:^(NSDictionary *dataDict) {
        NSURL *imageURL = [NSURL URLWithString:dataDict[@"app_icon_url"]];
        [self.recAppCell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(30, 30)]];
        self.recAppCell.textLabel.text = dataDict[@"app_name"];
        self.recAppCell.detailTextLabel.text = dataDict[@"app_describe"];
    } failure:nil];
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
