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

@interface ONEDetailTableViewController ()

@property (strong, nonatomic) ONEEssayItem *essayItem;

@property (strong, nonatomic) NSMutableArray<ONECommentItem *> *commentList;

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

- (void)setItemId:(NSString *)itemId {
    _itemId = itemId;
    
    [self loadDetailData];
    
    [self loadCommentData];
}

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - 初始化UI
- (void)setUpTableView {
    
}

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
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}





@end
