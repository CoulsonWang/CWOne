//
//  ONEAllEveryOneAskEveryOneView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllEveryOneAskEveryOneView.h"
#import "ONEAllEveryOneAskEveryOneCell.h"

static NSString *const cellID = @"ONEAllEveryOneAskEveryOneCell";

@interface ONEAllEveryOneAskEveryOneView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UILabel *label;

@end

@implementation ONEAllEveryOneAskEveryOneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= ONEAllSeperatorViewHeight;
    [super setFrame:frame];
}

- (void)setSpecialList:(NSArray<ONESpecialItem *> *)specialList {
    _specialList = specialList;
    [self.collectionView reloadData];
}

- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addLabel];
    [self setUpCollectionView];
}

- (void)addLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15.0 weight:-0.5];
    label.text = @"所有人问所有人";
    [label sizeToFit];
    label.frame = CGRectMake(20, 15, label.width, label.height);
    [self addSubview:label];
    self.label = label;
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(200, 130);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.label.frame) + 20, CWScreenW, 130) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEAllEveryOneAskEveryOneCell class]) bundle:nil] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.specialList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ONEAllEveryOneAskEveryOneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    ONESpecialItem *specialItem = self.specialList[indexPath.item];
    
    cell.specialItem = specialItem;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转
}

@end
