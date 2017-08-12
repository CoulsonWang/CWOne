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
#import "ONEHomeFeedDatePickerView.h"

#define kFeedSideMargin 20.0
#define kFeedDistance 20.0
#define kFeedLineSpacing 10.0
#define kBottomDatePickerHeight 39.0
#define kLoadingImageHeight 35
#define kSectionHeaderViewHeight 50.0

#define kRowHeight (CWScreenW - 2* kFeedSideMargin - kFeedSideMargin) * 0.5 + kFeedLineSpacing

static NSString *const cellID = @"ONEHomeFeedCellID";
static NSString *const headerID = @"ONEHomeFeedHeaderID";

@interface ONEHomeFeedsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ONEHomeFeedBottomPickerViewDelegate, ONEHomeFeedDatePickerViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) ONEHomeFeedBottomPickerView *bottomView;

@property (weak, nonatomic) FLAnimatedImageView *loadingImageView;

@property (weak, nonatomic) ONEHomeFeedDatePickerView *pickerView;

@property (strong, nonatomic) NSMutableArray<NSArray<ONEFeedItem *> *> *feedsList;

@end

@implementation ONEHomeFeedsViewController

-(ONEHomeFeedDatePickerView *)pickerView {
    if (!_pickerView) {
        ONEHomeFeedDatePickerView *pickerView = [[ONEHomeFeedDatePickerView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH)];
        pickerView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
        _pickerView = pickerView;
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpCollectionView];
    
    [self setUpBottomPickerView];
    
    [self setUpLoadingView];
}

#pragma mark - 设置界面
- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (CWScreenW - 2 * kFeedSideMargin - kFeedDistance) * 0.5;
    flowLayout.itemSize = CGSizeMake(width, width);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = kFeedDistance;
    flowLayout.minimumLineSpacing = kFeedLineSpacing;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kFeedSideMargin, 0, kFeedSideMargin);
    flowLayout.headerReferenceSize = CGSizeMake(CWScreenW, kSectionHeaderViewHeight);
    
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
    bottomView.delegate = self;
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

#pragma mark - setter方法
- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    self.bottomView.dateString = dateString;
    [self loadFeedsData];
}

#pragma mark - 私有方法
- (void)loadFeedsData {
    NSString *dateString = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:self.dateString];
    [self loadFeedsDataWithDateString:dateString completion:^{
        [self makeCurrentDateCellVisible];
    }];
    
}

- (void)loadFeedsDataWithDateString:(NSString *)dateString completion:(void(^)())completion {
    self.loadingImageView.hidden = NO;
    self.collectionView.hidden = YES;
    self.bottomView.hidden = YES;
    
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
        if (completion) {
            completion();
        }
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

- (void)makeCurrentDateCellVisible {
    // 将CollectionView移动到能看到当前日期对应的cell的位置
    for (int i = 0; i < self.feedsList.firstObject.count; i++) {
        ONEFeedItem *feedItem = self.feedsList.firstObject[i];
        if ([feedItem.date isEqualToString:self.dateString]) {
            NSInteger row = (i + 1) * 0.5;
            CGFloat offsetY = row * kRowHeight + kSectionHeaderViewHeight - CWScreenH * 0.5 + kNavigationBarHeight;
            self.collectionView.contentOffset = CGPointMake(0, offsetY);
            break;
        }
    }
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
    cell.isToday = [feedItem.date isEqualToString:self.dateString];
    
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
    ONEHomeFeedCell *cell = (ONEHomeFeedCell *)[self.collectionView visibleCells].firstObject;
    NSString *cellDate = cell.feedItem.date;
    
    NSString *cellDateStr = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:cellDate];
    NSString *bottomDateStr = [[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:self.bottomView.dateString];
    if (cellDate != nil && ![cellDateStr isEqualToString:bottomDateStr]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bottomView.dateString = cellDate;
        });
    }
}

#pragma mark - ONEHomeFeedBottomPickerViewDelegate
- (void)feedDatePickViewDidClick:(ONEHomeFeedBottomPickerView *)pickView {
    // 弹出日期选择器
    [self.pickerView appearWithDateString:self.bottomView.dateString];
}
#pragma mark - ONEHomeFeedDatePickerViewDelegate
- (void)feedDataPicker:(ONEHomeFeedDatePickerView *)feedDatePickerView didConfirmSelectedWithDateString:(NSString *)dateString {
    // 先查找目前已加载的数组中是否已有目标日期
    for (NSArray<ONEFeedItem *> *feeds in self.feedsList) {
        // 如果有，直接滚动collectionView到对应位置
        if ([[[ONEDateTool sharedInstance] getFeedsRequestDateStringWithOriginalDateString:feeds.firstObject.date] isEqualToString:dateString]) {
            NSInteger section = [self.feedsList indexOfObject:feeds];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            return;
        }
    }
    // 如果遍历完数组都没有，则重新加载数据
    [self loadFeedsDataWithDateString:dateString completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollViewDidScroll:self.collectionView];
        });
        
    }];
}
@end
