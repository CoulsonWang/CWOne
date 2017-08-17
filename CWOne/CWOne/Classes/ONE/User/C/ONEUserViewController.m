//
//  ONEUserViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEUserViewController.h"
#import "ONEUserHeaderView.h"
#import "ONENavigationBarTool.h"
#import "ONENetworkTool.h"
#import "ONEUserItem.h"
#import "ONEUserInfoItem.h"

#define UserCollectionCategoryNameArray @[@"图文",@"阅读",@"音乐",@"电影",@"深夜电台"]
#define UserCollectionCategoryImageNameArray @[@"user_center_imagetext",@"user_center_read",@"user_center_music",@"user_center_film",@"user_center_FM"]

static NSString *const cellID = @"ONEUserCollectionViewCellID";

@interface ONEUserViewController ()

@property (strong, nonatomic) ONEUserInfoItem *userInfoItem;

@property (strong, nonatomic) ONEUserHeaderView *userHeaderView;

@end

@implementation ONEUserViewController

#pragma mark - 懒加载
- (ONEUserHeaderView *)userHeaderView {
    if (!_userHeaderView) {
        ONEUserHeaderView *userHeaderView = [ONEUserHeaderView userHeaderView];
        userHeaderView.frame = CGRectMake(0, 0, CWScreenW, 375);
        self.tableView.tableHeaderView = userHeaderView;
        _userHeaderView = userHeaderView;
    }
    return _userHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ONENavigationBarTool sharedInstance] updateCurrentViewController:self];
    [[ONENavigationBarTool sharedInstance] changeNavigationBarToLucencyMode];
}

- (void)setUpNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_default"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissUserVC)];
}

- (void)setUpTableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setUserItem:(ONEUserItem *)userItem {
    _userItem = userItem;
    
    [self loadData];
}

- (void)setUserInfoItem:(ONEUserInfoItem *)userInfoItem {
    _userInfoItem = userInfoItem;
    
    self.userHeaderView.userInfoItem = userInfoItem;
}

- (void)loadData {
    // 加载基本信息
    [[ONENetworkTool sharedInstance] requestUserInfoDataWithUserId:self.userItem.user_id success:^(NSDictionary *dataDict) {
         self.userInfoItem = [ONEUserInfoItem userInfoItemWithDict:dataDict];
    } failure:nil];
    
    [[ONENetworkTool sharedInstance] requestUserFollowListCountWithUserId:self.userItem.user_id success:^(NSArray *dataArray) {
        self.userInfoItem.followList = dataArray;
    } failure:nil];
}

#pragma mark - 事件响应
- (void)dismissUserVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return UserCollectionCategoryNameArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0 weight:-0.3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = @"TA的关注";
        cell.imageView.image = [UIImage imageNamed:@"user_center_following"];
    } else {
        cell.textLabel.text = UserCollectionCategoryNameArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:UserCollectionCategoryImageNameArray[indexPath.row]];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return @"ta的收藏";
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    [self.userHeaderView updateBackgroundViewHeightWithOffsetY:offsetY];
}
@end
