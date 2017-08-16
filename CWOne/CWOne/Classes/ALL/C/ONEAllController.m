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

#define kBannerRatio 229/384.0
#define kSeperatorViewHeight 10.0

static NSString *const cellID = @"ONEAllSpecialTableViewCell";

@interface ONEAllController () <CWCarouselViewDelegate>

@property (strong, nonatomic) NSArray<ONESpecialItem *> *stickSpecialList;
@property (strong, nonatomic) NSArray<ONESpecialItem *> *normalSpecialList;
@property (strong, nonatomic) NSArray<ONESpecialItem *> *bannerSpecialList;
@property (strong, nonatomic) NSArray<ONEUserItem *> *hotAuthorList;
@property (strong, nonatomic) NSArray<ONESpecialItem *> *everyOneAskEveryOneSpecialList;

@property (weak, nonatomic) CWCarouselView *bannerView;

@end

@implementation ONEAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpTableViewHeader];
    
    [self setUpNavigationBar];
    
    [self loadData];
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
    self.tableView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1.0];
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEAllSpecialTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

- (void)setUpTableViewHeader {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenW * kBannerRatio + kSeperatorViewHeight)];
    self.tableView.tableHeaderView = headerView;
    
    CWCarouselView *bannerView = [CWCarouselView carouselViewWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenW * kBannerRatio) imageUrls:nil placeholder:nil];
    bannerView.delegate = self;
    bannerView.interval = 1.8;
    bannerView.scrollAnimationDuration = 0.35;
    bannerView.pageControlPostion = CWPageControlPostionTopRight;
    [headerView addSubview:bannerView];
    self.bannerView = bannerView;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CWScreenW * kBannerRatio, CWScreenW, kSeperatorViewHeight)];
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
            BOOL is_stick = dataDict[@"is_stick"];
            is_stick ? [stickArray addObject:specialItem] : [notStickArray addObject:specialItem];
        }
        self.stickSpecialList = stickArray;
        self.normalSpecialList = notStickArray;
        [self.tableView reloadData];
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
#pragma mark - 事件响应
- (void)searchButtonClick {
    [[ONESearchTool sharedInstance] presentSearchViewController];
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
        // 显示轮播器和分类导航
    } else {
        // 显示所有人问所有人
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        // 显示近期热门作者列表
    }
    return nil;
}
#pragma mark - CWCarouselViewDelegate
- (void)carouselView:(CWCarouselView *)carouselView didClickImageOnIndex:(NSUInteger)index {
    
}
@end
