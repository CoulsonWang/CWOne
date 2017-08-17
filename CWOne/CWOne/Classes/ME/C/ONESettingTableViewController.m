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
#import "ONENavigationBarTool.h"

@interface ONESettingTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *recAppCell;

@end

@implementation ONESettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recAppCell.imageView.bounds = CGRectMake(0, 0, 30, 30);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"back_dark"] style:UIBarButtonItemStylePlain target:self action:@selector(popVC)];
    self.title = @"设置";
    
    [[ONENetworkTool sharedInstance] requestRecAppListSuccess:^(NSDictionary *dataDict) {
        NSURL *imageURL = [NSURL URLWithString:dataDict[@"app_icon_url"]];
        [self.recAppCell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(30, 30)]];
        self.recAppCell.textLabel.text = dataDict[@"app_name"];
        self.recAppCell.detailTextLabel.text = dataDict[@"app_describe"];
    } failure:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[ONENavigationBarTool sharedInstance] resumeNavigationBar];
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
