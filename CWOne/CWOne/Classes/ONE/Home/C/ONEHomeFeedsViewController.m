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
#import "ONEHomeFeedBottomPickerView.h"
#import <FLAnimatedImage.h>

#define kFeedSideMargin 20.0
#define kFeedDistance 20.0
#define kFeedLineSpacing 10.0
#define kBottomDatePickerHeight 39.0
#define kLoadingImageHeight 35

static NSString *const cellID = @"ONEHomeFeedCellID";
static NSString *const headerID = @"ONEHomeFeedHeaderID";

@interface ONEHomeFeedsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) ONEHomeFeedBottomPickerView *bottomView;

@property (weak, nonatomic) FLAnimatedImageView *loadingImageView;

@property (strong, nonatomic) NSMutableArray<NSArray<ONEFeedItem *> *> *feedsList;

@end

@implementation ONEHomeFeedsViewController

#pragma mark - 懒加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpCollectionView];
    
    [self setUpBottomPickerView];
    
    [self setUpLoadingView];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (CWScreenW - 2 * kFeedSideMargin - kFeedDistance) * 0.5;
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = kFeedDistance;
    flowLayout.minimumLineSpacing = kFeedLineSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kFeedSideMargin, 0, kFeedSideMargin);
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
     ONEHomeFeedBottomPickerView *bottomView = [[ONEHomeFeedBottomPickerView alloc] initWithFrame:CGRectMake(0, CWScreenH - kBottomDatePickerHeight, CWScreenW, kBottomDatePickerHeight)];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setUpLoadingView {
    NSURL *imgUrl = [[NSBundle mainBundle] URLForResource:@"loading@2x" withExtension:@"gif"];
    FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:imgUrl]];
    FLAnimatedImageView *gifView = [[FLAnimatedImageView alloc] init];
    gifView.animatedImage = animatedImg;
    gifView.frame = CGRectMake((CWScreenW - kLoadingImageHeight) * 0.5, (CWScreenH - kLoadingImageHeight) * 0.5 , kLoadingImageHeight, kLoadingImageHeight);
    [self.view addSubview:gifView];
    self.loadingImageView = gifView;
}

- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    
    self.bottomView.dateString = dateString;
    [self loadFeedsData];
}

#pragma mark - 事件响应
- (void)loadFeedsData {
    self.loadingImageView.hidden = NO;
    self.collectionView.hidden = YES;
    self.bottomView.hidden = YES;
    
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
        
        self.collectionView.hidden = NO;
        self.bottomView.hidden= NO;
        self.loadingImageView.hidden = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadNewerFeedsData {
    NSString *newestDateString = self.feedsList.firstObject.firstObject.date;
    NSString *nextMonthDateString = [[ONEDateTool sharedInstance] getNextMonthDateStringWithDateString:newestDateString];
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
    NSString *lastMonthDateString = [[ONEDateTool sharedInstance] getLastMonthDateStringWithDateString:oldestDateString];
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

#pragma mark - UICollectionViewDelegate 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 发送通知，通知标题视图收起
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEFeedsDidSelectedNotification object:nil];
    
    // 通知代理跳转界面
    NSArray *feeds = self.feedsList[indexPath.section];
    ONEFeedItem *feedItem = feeds[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(feedsViewController:didSelectedCollectionViewWithDateString:)]) {
        [self.delegate feedsViewController:self didSelectedCollectionViewWithDateString:feedItem.date];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat lineHeight = (CWScreenW - 2* kFeedSideMargin - kFeedSideMargin) * 0.5 + kFeedLineSpacing;
    NSInteger row = offsetY / lineHeight;
    
    NSInteger rowSum = 0;
    for (NSArray<ONEFeedItem *> *feeds in self.feedsList) {
        NSInteger feedsRow = (feeds.count + 1) * 0.5;
        rowSum += feedsRow;
        if (row < rowSum) {
            if (![self.bottomView.dateString isEqualToString:feeds.firstObject.date]) {
                self.bottomView.dateString = feeds.firstObject.date;
            }
            break;
        }
    }
}
@end
