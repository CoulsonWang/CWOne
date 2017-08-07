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

#define kWebViewMinusHeight 80.0
#define kScrollAnimationDuration 0.3
#define kNavTitleChangeValue 64.0

static NSString *const cellID = @"ONEDetailCommentCellID";

@interface ONEDetailTableViewController () <UIWebViewDelegate>

@property (strong, nonatomic) ONEEssayItem *essayItem;

@property (strong, nonatomic) NSMutableArray<ONECommentItem *> *commentList;

@property (weak, nonatomic) UIWebView *headerWebView;

@property (assign, nonatomic) CGFloat lastOffsetY;

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

- (UIWebView *)headerWebView {
    if (!_headerWebView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH)];
        webView.delegate = self;
        webView.scrollView.scrollEnabled = NO;
        self.tableView.tableHeaderView = webView;
        _headerWebView = webView;
    }
    return _headerWebView;
}

- (void)setItemId:(NSString *)itemId {
    _itemId = itemId;
    
    [self loadDetailData];
    
    [self loadCommentData];
}

- (void)setEssayItem:(ONEEssayItem *)essayItem {
    _essayItem = essayItem;
    
    [self webViewLoadHtmlData];
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

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [self setUpFooter];
    
    [self setUpNotification];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化UI
- (void)setUpTableView {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setUpFooter {
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreCommentData)];
}

- (void)setUpNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movePageToComment) name:ONEDetailToolViewCommentButtonClickNotification object:nil];
}

#pragma mark - 私有工具方法
- (void)loadDetailData {
    [[ONENetworkTool sharedInstance] requestEssayDetailDataWithItemID:self.itemId success:^(NSDictionary *dataDict) {
        self.essayItem = [ONEEssayItem essayItemWithDict:dataDict];
        if ([self.delegate respondsToSelector:@selector(detailTableVC:updateToolViewPraiseCount:andCommentCount:)]) {
            [self.delegate detailTableVC:self updateToolViewPraiseCount:_essayItem.praisenum andCommentCount:_essayItem.commentnum];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadCommentData {
    [[ONENetworkTool sharedInstance] requestEssayCommentListWithItemID:self.itemId lastID:nil success:^(NSArray<NSDictionary *> *dataArray) {
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

- (void)webViewLoadHtmlData {
    [self.headerWebView loadHTMLString:self.essayItem.html_content baseURL:nil];
}
                                
- (void)loadMoreCommentData {
    NSString *lastCommentID = self.commentList.lastObject.commentID;
    [[ONENetworkTool sharedInstance] requestEssayCommentListWithItemID:self.itemId lastID:lastCommentID success:^(NSArray<NSDictionary *> *dataArray) {
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
    CGFloat offsetY = self.headerWebView.height - CWScreenH * 0.5;
    [UIView animateWithDuration:kScrollAnimationDuration animations:^{
        self.tableView.contentOffset = CGPointMake(0, offsetY);
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    ONECommentItem *commentItem = self.commentList[indexPath.row];
    
    cell.commentItem = commentItem;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 改变NavBar的高度
    if (scrollView.contentOffset.y - self.lastOffsetY > 0 && scrollView.contentOffset.y > -kNavigationBarHeight) {
        [[ONENavigationBarTool sharedInstance] hideNavigationBar];
    } else {
        [[ONENavigationBarTool sharedInstance] resumeNavigationBar];
        // 修改标题
        if (scrollView.contentOffset.y >= kNavTitleChangeValue) {
            [self.delegate detailTableVC:self UpdateTitle:self.essayItem.title];
        } else {
            if (self.essayItem.tagTitle) {
                [self.delegate detailTableVC:self UpdateTitle:self.essayItem.tagTitle];
            } else {
                [self.delegate detailTableVC:self UpdateTitle:nil];
            }
            
        }
    }
    
    self.lastOffsetY = scrollView.contentOffset.y;
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    self.headerWebView.frame = CGRectMake(0, 0, CWScreenW, webViewHeight - kWebViewMinusHeight);
    [self.tableView reloadData];
    self.parentViewController.title = self.essayItem.title;
    
    // 通知外部控制器切换视图
    if ([self.delegate respondsToSelector:@selector(detailTableVCDidFinishLoadData:)]) {
        [self.delegate detailTableVCDidFinishLoadData:self];
    }
}


@end
