//
//  ONEHomeFeedsViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/10.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeFeedsViewController.h"
#import "ONENetworkTool.h"
#import "ONEDateTool.h"
#import "ONEFeedItem.h"
#import "ONEHomeFeedCell.h"
#import "ONEHomeFeedHeaderView.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>

#define kFeedSideMargin 20.0
#define kFeedDistance 20.0
#define kFeedLineSpacing 10.0
#define kBottomDatePickerHeight 44.0
#define kCollectionViewBottomInset 20.0

static NSString *const cellID = @"ONEHomeFeedCellID";
static NSString *const headerID = @"ONEHomeFeedHeaderID";

@interface ONEHomeFeedsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray<NSArray<ONEFeedItem *> *> *feedsList;

@end

@implementation ONEHomeFeedsViewController

#pragma mark - 懒加载

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpCollectionView];
    
    [self setUpBottomPickerView];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (CWScreenW - 2 * kFeedSideMargin - kFeedDistance) * 0.5;
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = kFeedDistance;
    flowLayout.minimumLineSpacing = kFeedLineSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kFeedSideMargin, kCollectionViewBottomInset, kFeedSideMargin);
    flowLayout.headerReferenceSize = CGSizeMake(CWScreenW, 50);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, kBottomDatePickerHeight, 0);
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeFeedCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeFeedHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewerFeedsData)];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden= YES;
    refreshHeader.arrowView.alpha = 0;
    collectionView.mj_header = refreshHeader;
    
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOlderFeedsData)];
    collectionView.mj_footer = refreshFooter;
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setUpBottomPickerView {
    
}

- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    [self loadFeedsData];
}

#pragma mark - 事件响应
- (void)loadFeedsData {
    NSString *dateString = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:self.dateString];
    [[ONENetworkTool sharedInstance] requestFeedsDataWithDateString:dateString success:^(NSArray *dataArray) {
        NSMutableArray<NSArray<ONEFeedItem *> *> *feedsList = [NSMutableArray array];
        NSMutableArray<ONEFeedItem *> *feeds = [NSMutableArray array];
        for (NSDictionary *dict in dataArray) {
            ONEFeedItem *feedItem = [ONEFeedItem feedItemWithDict:dict];
            [feeds addObject:feedItem];
        }
        [feedsList addObject:feeds];
        self.feedsList = feedsList;
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadNewerFeedsData {
    NSString *dateString = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:self.dateString];
    NSString *nextMonthDateString = [[ONEDateTool sharedInstance] getNextMonthDateStringWithCurrentMonthDateString:dateString];
    [[ONENetworkTool sharedInstance] requestFeedsDataWithDateString:nextMonthDateString success:^(NSArray *dataArray) {
        if (dataArray.count == 0) {
            [SVProgressHUD showImage:nil status:@"没有更多内容"];
            [SVProgressHUD dismissWithDelay:1.5];
            [self.collectionView.mj_header endRefreshing];
        } else {
            NSMutableArray<ONEFeedItem *> *feeds = [NSMutableArray array];
            for (NSDictionary *dict in dataArray) {
                ONEFeedItem *feedItem = [ONEFeedItem feedItemWithDict:dict];
                [feeds addObject:feedItem];
            }
            [self.feedsList insertObject:feeds atIndex:0];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadOlderFeedsData {
    NSString *oldestDateString = self.feedsList.lastObject.lastObject.date;
    NSString *dateString = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:oldestDateString];
    NSString *lastMonthDateString = [[ONEDateTool sharedInstance] getLastMonthDateStringWithCurrentMonthDateString:dateString];
    [[ONENetworkTool sharedInstance] requestFeedsDataWithDateString:lastMonthDateString success:^(NSArray *dataArray) {
        if (dataArray.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            NSMutableArray<ONEFeedItem *> *feeds = [NSMutableArray array];
            for (NSDictionary *dict in dataArray) {
                ONEFeedItem *feedItem = [ONEFeedItem feedItemWithDict:dict];
                [feeds addObject:feedItem];
            }
            [self.feedsList addObject:feeds];
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.feedsList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *feeds = self.feedsList[section];
    return feeds.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ONEHomeFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    NSArray *feeds = self.feedsList[indexPath.section];
    ONEFeedItem *feedItem = feeds[indexPath.item];
    
    cell.feedItem = feedItem;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ONEHomeFeedHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    headerView.dateString = self.feedsList[indexPath.section].firstObject.date;
    return headerView;
    
}
@end
