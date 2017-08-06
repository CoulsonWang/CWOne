//
//  ONEDetailTableViewController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/5.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailTableViewController.h"
#import "ONENetworkTool.h"
#import "ONEEssayItem.h"
#import "ONECommentItem.h"
#import "ONEDetailCommentCell.h"

#define kWebViewMinusHeight 80.0

static NSString *const cellID = @"ONEDetailCommentCellID";

@interface ONEDetailTableViewController () <UIWebViewDelegate>

@property (strong, nonatomic) ONEEssayItem *essayItem;

@property (strong, nonatomic) NSMutableArray<ONECommentItem *> *commentList;

@property (weak, nonatomic) UIWebView *headerWebView;

@property (assign, nonatomic) CGFloat lastOffsetY;

@end

@implementation ONEDetailTableViewController

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
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, 0)];
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

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEDetailCommentCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

#pragma mark - 初始化UI

#pragma mark - 私有工具方法
- (void)loadDetailData {
    [[ONENetworkTool sharedInstance] requestEssayDetailDataWithItemID:self.itemId success:^(NSDictionary *dataDict) {
        self.essayItem = [ONEEssayItem essayItemWithDict:dataDict];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadCommentData {
    [[ONENetworkTool sharedInstance] requestEssayCommentListWithItemID:self.itemId lastID:nil success:^(NSArray<NSDictionary *> *dateArray) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dataDict in dateArray) {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    ONECommentItem *commentItem = self.commentList[indexPath.row];
    
    cell.textLabel.text = commentItem.content;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 改变NavBar的高度
    if (scrollView.contentOffset.y - self.lastOffsetY > 0) {
        // 隐藏
        self.navigationController.navigationBar.alpha = 0.0;
    } else {
        self.navigationController.navigationBar.alpha = 1.0;
    }
    // 修改标题
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue];
    self.headerWebView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, webViewHeight - kWebViewMinusHeight);
    [self.tableView reloadData];
}


@end
