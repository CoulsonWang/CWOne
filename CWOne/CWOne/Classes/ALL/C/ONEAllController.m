//
//  ONEAllController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllController.h"
#import "UIImage+Render.h"
#import "ONESearchTool.h"
#import "ONENetworkTool.h"
#import "ONESpecialItem.h"
#import "ONEUserItem.h"
#import "ONEAllSpecialTableViewCell.h"
#import "CWCarouselView.h"
#import "ONEAllHotAuthorView.h"
#import "ONEAllCategoryNavigationView.h"
#import "ONEAllEveryOneAskEveryOneView.h"
#import <MJRefresh.h>
#import "ONESearchAllListViewController.h"
#import "ONEDetailViewController.h"
#import "ONEHomeItem.h"
#import "ONENavigationBarTool.h"
#import <SafariServices/SafariServices.h>
#import "ONEAuthorInfoController.h"

#define kBannerRatio 229/384.0
#define kCategoryNavigationRatio 242/381.0
#define kEveryOneAskEveryOneRatio 190/380.0
#define kHotAuthorRatio 315/382.0

static NSString *const cellID = @"ONEAllSpecialTableViewCell";

@interface ONEAllController () <CWCarouselViewDelegate, ONEAllCategoryNavigationViewDelegate, ONEAllEveryOneAskEveryOneViewDelegate>

@property (strong, nonatomic) NSArray<ONESpecialItem *> *stickSpecialList;
@property (strong, nonatomic) NSArray<ONESpecialItem *> *normalSpecialList;
@property (strong, nonatomic) NSArray<ONESpecialItem *> *bannerSpecialList;
@property (strong, nonatomic) NSArray<ONEUserItem *> *hotAuthorList;
@property (strong, nonatomic) NSArray<ONESpecialItem *> *everyOneAskEveryOneSpecialList;

@property (weak, nonatomic) CWCarouselView *bannerView;
@property (strong, nonatomic) ONEAllHotAuthorView *hotAuthorView;
@property (strong, nonatomic) ONEAllEveryOneAskEveryOneView *everyOneAskEveryOneView;

@end

@implementation ONEAllController

#pragma mark - 懒加载
- (ONEAllHotAuthorView *)hotAuthorView {
    if (!_hotAuthorView) {
        __weak typeof(self) weakSelf = self;
        ONEAllHotAuthorView *hotAuthorView = [ONEAllHotAuthorView hotAuthorViewWithClickOperation:^(ONEUserItem *author) {
            ONEAuthorInfoController *authorVC = [[ONEAuthorInfoController alloc] initWithStyle:UITableViewStyleGrouped];
            authorVC.author = author;
            [weakSelf.navigationController showViewController:authorVC sender:nil];
        }];
        _hotAuthorView = hotAuthorView;
    }
    return _hotAuthorView;
}

- (ONEAllEveryOneAskEveryOneView *)everyOneAskEveryOneView {
    if (!_everyOneAskEveryOneView) {
        ONEAllEveryOneAskEveryOneView *everyOneView = [[ONEAllEveryOneAskEveryOneView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenW * kEveryOneAskEveryOneRatio)];
        everyOneView.delegate = self;
        _everyOneAskEveryOneView = everyOneView;
    }
    return _everyOneAskEveryOneView;
}

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpTableViewHeader];
    
    [self setUpNavigationBar];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[ONENavigationBarTool sharedInstance] updateCurrentViewController:self];
    [[ONENavigationBarTool sharedInstance] resumeNavigationBar];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
#pragma mark - 初始化
- (void)setUpNavigationBar {
    // 标题
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_title_view"]];
    self.navigationItem.titleView = titleImageView;
    
    // 搜索按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalRenderMode:@"search_gray"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonClick)];
}

- (void)setUpTableView {
    self.tableView.backgroundColor = ONEBackgroundColor;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEAllSpecialTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.backgroundColor = ONEBackgroundColor;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreSpecialData)];
}

- (void)setUpTableViewHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenW * kBannerRatio + ONEAllSeperatorViewHeight)];
    self.tableView.tableHeaderView = headerView;
    
    CWCarouselView *bannerView = [CWCarouselView carouselViewWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenW * kBannerRatio) imageUrls:nil placeholder:nil];
    bannerView.delegate = self;
    bannerView.interval = 1.8;
    bannerView.scrollAnimationDuration = 0.35;
    bannerView.pageControlPostion = CWPageControlPostionTopRight;
    [headerView addSubview:bannerView];
    self.bannerView = bannerView;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CWScreenW * kBannerRatio, CWScreenW, ONEAllSeperatorViewHeight)];
    seperatorView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1.0];
    [headerView addSubview:seperatorView];
}

- (void)loadData {
    // 请求轮播器数据
    [[ONENetworkTool sharedInstance] requestAllHeaderBannerDataWithLastId:nil success:^(NSArray *dataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dataDict in dataArray) {
            ONESpecialItem *specialItem = [ONESpecialItem specialItemWithDict:dataDict];
            [tempArray addObject:specialItem];
        }
        self.bannerSpecialList = tempArray;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    // 请求热门作者数据
    [[ONENetworkTool sharedInstance] requestAllHotAuthorListDataSuccess:^(NSArray *dataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dataDict in dataArray) {
            ONEUserItem *userItem = [ONEUserItem userItemWithDict:dataDict];
            [tempArray addObject:userItem];
        }
        self.hotAuthorList = tempArray;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    // 请求所有人问所有人数据
    [[ONENetworkTool sharedInstance] requestAllEveryOneAskEveryOneDataWithLastId:nil success:^(NSArray *dataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dataDict in dataArray) {
            ONESpecialItem *specialItem = [ONESpecialItem specialItemWithDict:dataDict];
            [tempArray addObject:specialItem];
        }
        self.everyOneAskEveryOneSpecialList = tempArray;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    // 请求专题列表数据
    [[ONENetworkTool sharedInstance] requestAllSpecilaListDataWithLastId:nil success:^(NSArray *dataArray) {
        NSMutableArray *stickArray = [NSMutableArray array];
        NSMutableArray *notStickArray = [NSMutableArray array];
        for (NSDictionary *dataDict in dataArray) {
            ONESpecialItem *specialItem = [ONESpecialItem specialItemWithDict:dataDict];
            BOOL is_stick = [dataDict[@"is_stick"] integerValue];
            is_stick ? [stickArray addObject:specialItem] : [notStickArray addObject:specialItem];
        }
        self.stickSpecialList = stickArray;
        self.normalSpecialList = notStickArray;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - setter方法
- (void)setBannerSpecialList:(NSArray<ONESpecialItem *> *)bannerSpecialList {
    _bannerSpecialList = bannerSpecialList;
    
    NSMutableArray<NSURL *> *imgUrlArray = [NSMutableArray array];
    for (ONESpecialItem *specialItem in bannerSpecialList) {
        NSURL *coverURL = [NSURL URLWithString:specialItem.cover];
        [imgUrlArray addObject:coverURL];
    }
    self.bannerView.imageUrls = imgUrlArray;
}
- (void)setHotAuthorList:(NSArray<ONEUserItem *> *)hotAuthorList {
    _hotAuthorList = hotAuthorList;
    self.hotAuthorView.hotAuthorList = hotAuthorList;
}
- (void)setEveryOneAskEveryOneSpecialList:(NSArray<ONESpecialItem *> *)everyOneAskEveryOneSpecialList {
    _everyOneAskEveryOneSpecialList = everyOneAskEveryOneSpecialList;
    self.everyOneAskEveryOneView.specialList = everyOneAskEveryOneSpecialList;
}
#pragma mark - 事件响应
- (void)searchButtonClick {
    [[ONESearchTool sharedInstance] presentSearchViewController];
}

- (void)loadMoreSpecialData {
    NSString *lastID = [NSString stringWithFormat:@"%ld",self.normalSpecialList.lastObject.id];
    [[ONENetworkTool sharedInstance] requestAllSpecilaListDataWithLastId:lastID success:^(NSArray *dataArray) {
        if (dataArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            NSMutableArray *tempArrya = [self.normalSpecialList mutableCopy];
            for (NSDictionary *dataDict in dataArray) {
                ONESpecialItem *specialItem = [ONESpecialItem specialItemWithDict:dataDict];
                [tempArrya addObject:specialItem];
            }
            self.normalSpecialList = tempArrya;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - 私有方法
- (void)pushToDetailVCWithSpecialItem:(ONESpecialItem *)specialItem {
    ONEDetailViewController *detailVC = [[ONEDetailViewController alloc] init];
    detailVC.homeItem = [ONEHomeItem homeItemWithSpecialItem:specialItem];
    [self.navigationController showViewController:detailVC sender:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.stickSpecialList.count;
    } else {
        return self.normalSpecialList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEAllSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    ONESpecialItem *specialItem;
    if (indexPath.section == 0) {
        specialItem = self.stickSpecialList[indexPath.row];
    } else {
        specialItem = self.normalSpecialList[indexPath.row];
    }
    cell.specialItem = specialItem;
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        // 分类导航
        ONEAllCategoryNavigationView *categoryView = [ONEAllCategoryNavigationView categoryNavigationView];
        categoryView.delegate = self;
        return categoryView;
    } else {
        // 显示所有人问所有人
        return self.everyOneAskEveryOneView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        // 显示近期热门作者列表
        return self.hotAuthorView;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CWScreenW * kHotAuthorRatio + ONEAllSeperatorViewHeight;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CWScreenW * kCategoryNavigationRatio + ONEAllSeperatorViewHeight;
    } else {
        return CWScreenW * kEveryOneAskEveryOneRatio + ONEAllSeperatorViewHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ONESpecialItem *specialItem;
    if (indexPath.section == 0) {
        specialItem = self.stickSpecialList[indexPath.row];
    } else {
        specialItem = self.normalSpecialList[indexPath.row];
    }
    [self pushToDetailVCWithSpecialItem:specialItem];
}
#pragma mark - CWCarouselViewDelegate
- (void)carouselView:(CWCarouselView *)carouselView didClickImageOnIndex:(NSUInteger)index {
    ONESpecialItem *specialItem = self.bannerSpecialList[index];
    if (specialItem.link_url != nil && specialItem.category != 11) {
        NSURL *adURL = [NSURL URLWithString:specialItem.link_url];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:adURL];
        [self presentViewController:safariVC animated:YES completion:nil];
    } else {
        [self pushToDetailVCWithSpecialItem:specialItem];
    }
}
#pragma mark - ONEAllCategoryNavigationViewDelegate
- (void)categoryNavigationView:(ONEAllCategoryNavigationView *)categoryNavigationView didClickButtonWithCategoryIndex:(NSInteger)categoryIndex {
    ONESearchAllListViewController *searchListVC = [[ONESearchAllListViewController alloc] init];
    searchListVC.categoryIndex = categoryIndex;
    searchListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:searchListVC sender:nil];
}
#pragma mark - ONEAllEveryOneAskEveryOneViewDelegate
- (void)everyOneAskEveryOneView:(ONEAllEveryOneAskEveryOneView *)everyOneAskEveryOneView didClickTopicWithSpecialItem:(ONESpecialItem *)specialItem {
    [self pushToDetailVCWithSpecialItem:specialItem];
}
@end
