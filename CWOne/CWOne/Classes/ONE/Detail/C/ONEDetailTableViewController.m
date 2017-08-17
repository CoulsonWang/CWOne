//
//  ONEDetailTableViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/5.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailTableViewController.h"
#import "ONEDetailViewController.h"
#import "ONENetworkTool.h"
#import "ONENavigationBarTool.h"
#import "ONEEssayItem.h"
#import "ONECommentItem.h"
#import "ONEDetailCommentCell.h"
#import <MJRefresh.h>
#import "NSString+CWTranslate.h"
#import "ONERelatedItem.h"
#import "ONEDetailRelatedCell.h"
#import "ONEDetailSectionHeaderView.h"
#import "ONEDetailTableHeaderView.h"


#define kNavTitleChangeValue 64.0
#define kSectionHeaderViewHeight 60.0
#define kLucencyModeSpace 100

static NSString *const ONEDetailCommentCellID = @"ONEDetailCommentCellID";
static NSString *const ONEDetailRelatedCellID = @"ONEDetailRelatedCellID";

@interface ONEDetailTableViewController () <ONEDetailTableHeaderViewDelegate>

@property (strong, nonatomic) ONEEssayItem *essayItem;

@property (strong, nonatomic) NSMutableArray<ONECommentItem *> *commentList;

@property (strong, nonatomic) NSArray<ONERelatedItem *> *relatedList;

@property (weak, nonatomic) ONEDetailTableHeaderView *tableHeaderView;

@property (assign, nonatomic) CGFloat lastOffsetY;

@property (assign, nonatomic, getter=isOnScreen) BOOL onScreen;

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *fontColor;
@end

@implementation ONEDetailTableViewController

@synthesize commentList = _commentList;

#pragma mark - 懒加载
- (NSMutableArray *)commentList {
    if (!_commentList) {
        NSMutableArray *commentList = [NSMutableArray array];
        _commentList = commentList;
    }
    return _commentList;
}

- (ONEDetailTableHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        ONEDetailTableHeaderView *tableHeaderView = [ONEDetailTableHeaderView detailTableHeaderViewWithType:self.type];
        tableHeaderView.delegate = self;
        self.tableView.tableHeaderView = tableHeaderView;
        _tableHeaderView = tableHeaderView;
    }
    return _tableHeaderView;
}

#pragma mark - setter方法
- (void)setItemId:(NSString *)itemId {
    _itemId = itemId;
    
    [self loadDetailData];
    
    [self loadCommentData];
    
    [self loadRelatedData];
}

- (void)setEssayItem:(ONEEssayItem *)essayItem {
    _essayItem = essayItem;
    
    self.tableHeaderView.essayItem = essayItem;
    
    self.backgroundColor = essayItem.backgroundColor;
    self.fontColor = essayItem.fontColor;
    
    NSString *htmlStr;
    switch (self.type) {
        case ONEHomeItemTypeMusic:
            htmlStr = essayItem.story;
            break;
        case ONEHomeItemTypeMovie:
            htmlStr = essayItem.content;
            break;
        default:
            htmlStr = essayItem.html_content;
            break;
    }
    [self.tableHeaderView webViewLoadHtmlDataWithHtmlString:htmlStr];
}

// 当给评论列表赋值时，处理一下，判断是否是最后一个热门评论
- (void)setCommentList:(NSMutableArray<ONECommentItem *> *)commentList {
    _commentList = commentList;
    
    for (int i = 0; i < commentList.count; i++) {
        if (commentList[i].isHot && !commentList[i+1].isHot) {
            self.commentList[i].lastHotComment = YES;
            break;
        }
    }
}
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    if (backgroundColor != nil) {
        self.tableView.backgroundColor = backgroundColor;
    }
}
- (void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
    if (fontColor != nil) {
        [self.delegate detailTableVC:self updateToolViewBackgroundColor:self.backgroundColor fontColor:fontColor];
        [self.tableView reloadData];
    }
}
#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpFooter];
    
    [self setUpNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.onScreen = YES;
    // 手动调用一次滚动，确保进入时nav的状态正确
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.onScreen = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化UI
- (void)setUpTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:ONEDetailCommentCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEDetailRelatedCell class]) bundle:nil] forCellReuseIdentifier:ONEDetailRelatedCellID];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.type == ONEHomeItemTypeMusic || self.type == ONEHomeItemTypeMovie || self.type == ONEHomeItemTypeRadio || self.type == ONEHomeItemTypeTopic) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
    }
}

- (void)setUpFooter {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentData)];
}

- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movePageToComment) name:ONEDetailToolViewCommentButtonClickNotification object:nil];
}

#pragma mark - 私有工具方法
- (void)loadDetailData {
    if (self.type == ONEHomeItemTypeMusic) {
        [[ONENetworkTool sharedInstance] requestMusicDetailDataWithItemId:self.itemId success:^(NSDictionary *dataDict) {
            self.essayItem = [ONEEssayItem essayItemWithDict:dataDict];
            [self.delegate detailTableVC:self updateToolViewPraiseAndCommentCountWithEssayItem:self.essayItem];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    } else if (self.type == ONEHomeItemTypeMovie) {
        [[ONENetworkTool sharedInstance] requestMovieDetailDataWithItemId:self.itemId success:^(NSDictionary *dataDict) {
            ONEEssayItem *movieItem = [ONEEssayItem essayItemWithDict:dataDict];
            // 加载完故事数据后再加载详情信息
            [[ONENetworkTool sharedInstance] requestMovieStoryDataWithItemId:self.itemId success:^(NSDictionary *dataDict) {
                [movieItem setMovieStroyDateWithDetailDict:dataDict];
                self.essayItem = movieItem;
                [self.delegate detailTableVC:self updateToolViewPraiseAndCommentCountWithEssayItem:self.essayItem];
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    } else {
        NSString *typeName = [NSString getTypeStrWithType:self.type];
        [[ONENetworkTool sharedInstance] requestDetailDataOfType:typeName withItemId:self.itemId success:^(NSDictionary *dataDict) {
            self.essayItem = [ONEEssayItem essayItemWithDict:dataDict];
            [self.delegate detailTableVC:self updateToolViewPraiseAndCommentCountWithEssayItem:self.essayItem];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
}

- (void)loadRelatedData {
    if (self.type == ONEHomeItemTypeTopic) { return; }
    NSString *typeName = [NSString getTypeStrWithType:self.type];
    [[ONENetworkTool sharedInstance] requestRelatedListDataOfType:typeName withItemId:self.itemId success:^(NSArray<NSDictionary *> *dataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dataDict in dataArray) {
            ONERelatedItem *relatedItem = [ONERelatedItem relatedItemWithDict:dataDict];
            [tempArray addObject:relatedItem];
        }
        self.relatedList = tempArray;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadCommentData {
    NSString *typeName = [NSString getTypeStrWithType:self.type];
    [[ONENetworkTool sharedInstance] requestCommentListOfType:typeName WithItemID:self.itemId lastID:nil success:^(NSArray<NSDictionary *> *dataArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dataDict in dataArray) {
            ONECommentItem *commentItem = [ONECommentItem commentItemWithDict:dataDict];
            [tempArray addObject:commentItem];
        }
        self.commentList = tempArray;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
                                
- (void)loadMoreCommentData {
    NSString *typeName = [NSString getTypeStrWithType:self.type];
    NSString *lastCommentID = self.commentList.lastObject.commentID;
    [[ONENetworkTool sharedInstance] requestCommentListOfType:typeName WithItemID:self.itemId lastID:lastCommentID success:^(NSArray<NSDictionary *> *dataArray) {
        if (dataArray.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        
        NSMutableArray *tempArray = [self.commentList mutableCopy];
        for (NSDictionary *dataDict in dataArray) {
            ONECommentItem *commentItem = [ONECommentItem commentItemWithDict:dataDict];
            [tempArray addObject:commentItem];
        }
        self.commentList = tempArray;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)movePageToComment {
    CGFloat offsetY = self.tableHeaderView.height - CWScreenH * 0.5;
    [self.tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.relatedList.count;
    } else {
        return self.commentList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ONEDetailRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:ONEDetailRelatedCellID forIndexPath:indexPath];
        ONERelatedItem *relatedItem = self.relatedList[indexPath.row];
        cell.relatedItem = relatedItem;
        return cell;
    } else {
        ONEDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ONEDetailCommentCellID forIndexPath:indexPath];
        ONECommentItem *commentItem = self.commentList[indexPath.row];
        cell.typeName = [NSString getTypeStrWithType:self.type];
        cell.commentItem = commentItem;
        cell.fontColor = self.fontColor;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.relatedList.count == 0) {
            return nil;
        } else {
            ONEDetailSectionHeaderView *sectionHeaderView = [ONEDetailSectionHeaderView sectionHeaderViewWithTitleString:@"相关推荐"];
            return sectionHeaderView;
        }
    } else {
        ONEDetailSectionHeaderView *sectionHeaderView = [ONEDetailSectionHeaderView sectionHeaderViewWithTitleString:@"评论列表"];
        return sectionHeaderView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.relatedList.count == 0) {
            return 0;
        } else {
            return kSectionHeaderViewHeight;
        }
    } else {
        return kSectionHeaderViewHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ONEDetailViewController *detailVC = [[ONEDetailViewController alloc] init];
        
        ONERelatedItem *relatedItem = self.relatedList[indexPath.row];
        NSDictionary *tempDict = @{@"item_id":relatedItem.content_id,
                                   @"category":[NSString stringWithFormat:@"%ld",relatedItem.category],
                                   @"title":relatedItem.title};
        ONEHomeItem *item = [ONEHomeItem homeItemWithDict:tempDict];
        detailVC.homeItem = item;
        
        [self.navigationController showViewController:detailVC sender:nil];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 处理导航条样式
    if (self.type == ONEHomeItemTypeMusic || self.type == ONEHomeItemTypeMovie || self.type == ONEHomeItemTypeRadio ||self.type == ONEHomeItemTypeTopic) {
        if (offsetY <= kLucencyModeSpace) {
            if (!self.isOnScreen) { return; }
            [[ONENavigationBarTool sharedInstance] changeNavigationBarTintColor:ONENavigationBarTintColorWhite];
            [[ONENavigationBarTool sharedInstance] changeNavigationBarToLucencyMode];
            [self.delegate detailTableVC:self UpdateTitle:@""];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            [self resumeNavigationStatus];
            [self updateNavBarHeightAndTitleWithOffsetY:offsetY];
        }
    } else {
        [self updateNavBarHeightAndTitleWithOffsetY:offsetY];
    }
    self.lastOffsetY = offsetY;
}

// 修改导航条的高度
- (void)updateNavBarHeightAndTitleWithOffsetY:(CGFloat)offsetY {
    // 改变NavBar的高度
    if (offsetY - self.lastOffsetY > 0 && offsetY > -kNavigationBarHeight) {
        [[ONENavigationBarTool sharedInstance] changeNavigationBarToShortMode];
    } else {
        [[ONENavigationBarTool sharedInstance] resumeNavigationBar];
        // 修改标题
        if (offsetY >= kNavTitleChangeValue) {
            [self.delegate detailTableVC:self UpdateTitle:self.essayItem.title];
        } else {
            if (self.essayItem.tagTitle) {
                [self.delegate detailTableVC:self UpdateTitle:self.essayItem.tagTitle];
            } else {
                [self.delegate detailTableVC:self UpdateTitle:nil];
            }
        }
    }
}

- (void)resumeNavigationStatus {
    [[ONENavigationBarTool sharedInstance] changeNavigationBarTintColor:ONENavigationBarTintColorGray];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - ONEDetailTableHeaderViewDelegate
- (void)detailTableHeaderView:(ONEDetailTableHeaderView *)detailTableHeaderView WebViewDidFinishLoadWithHeight:(CGFloat)webViewHeight {
    self.tableHeaderView.frame = CGRectMake(0, 0, CWScreenW, webViewHeight);
    [self.tableView reloadData];
    
    // 通知外部控制器切换视图
    if ([self.delegate respondsToSelector:@selector(detailTableVCDidFinishLoadData:)]) {
        [self.delegate detailTableVCDidFinishLoadData:self];
    }
}

@end
