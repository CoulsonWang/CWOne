//
//  ONEHomeCatalogueView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCatalogueView.h"
#import "ONEHomeMenuItem.h"
#import "ONECatalogueItem.h"
#import "ONEHomeCatalogueCell.h"

static NSString *const cellID = @"ONEHomeCatelogueCellID";

#define kTitleButtonHeight 40.0
#define kTitleButtonLabelWidth 100.0
#define kSeperateViewHeight 6.0
#define kCatalogueViewCurrentHeight CGRectGetMaxY(self.seperateView.frame)
#define kListViewBottomMargin 15.0

@interface ONEHomeCatalogueView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UIButton *titleButton;

@property (weak, nonatomic) UIImageView *arrowView;

@property (weak, nonatomic) UITableView *listView;

@property (strong, nonatomic) NSArray<ONECatalogueItem *> *cataLogueItems;

@property (weak, nonatomic) UIView *seperateView;

@property (assign, nonatomic, getter=isUnfold) BOOL unfold;

@end

@implementation ONEHomeCatalogueView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self arrowView];
        [self.listView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEHomeCatalogueCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        self.clipsToBounds = YES;
        
    }
    return self;
}

#pragma mark - 懒加载
- (UIButton *)titleButton {
    if (!_titleButton) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(0, 0, CWScreenW, kTitleButtonHeight);
        [titleButton setTitleColor:[UIColor colorWithWhite:122/255.0 alpha:1.0] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:titleButton];
        _titleButton = titleButton;
    }
    return _titleButton;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
        [arrowView sizeToFit];
        arrowView.centerY = self.titleButton.centerY;
        arrowView.x = CWScreenW * 0.5 + kTitleButtonLabelWidth * 0.5;
        [self addSubview:arrowView];
        _arrowView = arrowView;
    }
    return _arrowView;
}

- (UIView *)seperateView {
    if (!_seperateView) {
        UIView *seperateView = [[UIView alloc] init];
        seperateView.frame = CGRectMake(0, 0, CWScreenW, kSeperateViewHeight);
        seperateView.backgroundColor = ONEBackgroundColor;
        [self addSubview:seperateView];
        _seperateView = seperateView;
    }
    return _seperateView;
}

- (UITableView *)listView {
    if (!_listView) {
        UITableView *listView = [[UITableView alloc] init];
        listView.frame = CGRectMake(0, kTitleButtonHeight, CWScreenW, 0);
        listView.delegate = self;
        listView.dataSource = self;
        listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        listView.rowHeight = 70;
        [self addSubview:listView];
        _listView = listView;
    }
    return _listView;
}

- (void)setMenuItem:(ONEHomeMenuItem *)menuItem {
    _menuItem = menuItem;
    
    self.cataLogueItems = menuItem.catelogueItems;
    
    [self.titleButton setTitle:menuItem.titleString forState:UIControlStateNormal];
    
    self.listView.height = self.listView.rowHeight * self.cataLogueItems.count + kListViewBottomMargin;
    
    [self updateSubviewsFrame:self.isUnfold animated:NO];
    
    [self.listView reloadData];
}


#pragma mark - 事件响应
- (void)titleButtonClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [self changeArrowViewOrientationToUp:sender.isSelected];
    // 展开或收起
    [self updateSubviewsFrame:sender.isSelected animated:YES];
    
    self.unfold = sender.isSelected;
}

// 箭头方向变化
- (void)changeArrowViewOrientationToUp:(BOOL)isUp {

    self.arrowView.transform = isUp ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    
}

- (void)updateSubviewsFrame:(BOOL)isUnfold animated:(BOOL)animated{
    CGFloat duration = animated ? kCatalogueAnimationDuration : 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.seperateView.y = isUnfold ? CGRectGetMaxY(self.listView.frame) : kTitleButtonHeight;
        self.height = CGRectGetMaxY(self.seperateView.frame);
    }];
    self.catalogueHeight = self.height;
    self.updateFrame(isUnfold);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cataLogueItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEHomeCatalogueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.item = self.cataLogueItems[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    [[NSNotificationCenter defaultCenter] postNotificationName:ONEHomeShowDetailViaCatalogueNotification object:nil userInfo:@{ONEMenuItemKey : self.menuItem, ONEIndexKey : @(index)}];
}

@end
