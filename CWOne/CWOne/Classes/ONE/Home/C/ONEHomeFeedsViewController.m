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

@interface ONEHomeFeedsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray<NSArray<ONEFeedItem *> *> *feedsList;

@end

@implementation ONEHomeFeedsViewController

#pragma mark - 懒加载
- (NSMutableArray<NSArray<ONEFeedItem *> *> *)feedsList {
    if (!_feedsList) {
        NSMutableArray *feedsList = [NSMutableArray array];
        _feedsList = feedsList;
    }
    return _feedsList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, kNavigationBarHeight, CWScreenW, CWScreenH - kNavigationBarHeight);
    
    [self setUpCollectionView];
    
    [self setUpBottomPickerView];
}

- (void)setUpCollectionView {
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds];
    collectionView.dataSource = self;
    collectionView.delegate = self;
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
        NSMutableArray<ONEFeedItem *> *feeds = [NSMutableArray array];
        for (NSDictionary *dict in dataArray) {
            ONEFeedItem *feedItem = [ONEFeedItem feedItemWithDict:dict];
            [feeds addObject:feedItem];
        }
        [self.feedsList addObject:feeds];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
