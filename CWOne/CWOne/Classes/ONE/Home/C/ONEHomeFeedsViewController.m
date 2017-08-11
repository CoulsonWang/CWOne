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

#define kFeedSideMargin 20.0
#define kFeedDistance 20.0
#define kFeedLineSpacing 10.0

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
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kFeedSideMargin, 0, kFeedSideMargin);
    flowLayout.headerReferenceSize = CGSizeMake(CWScreenW - 2* kFeedSideMargin, 50);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeFeedCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeFeedHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
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
