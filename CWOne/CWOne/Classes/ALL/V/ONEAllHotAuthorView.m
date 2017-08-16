//
//  ONEAllHotAuthorView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllHotAuthorView.h"
#import "ONEAllHotAuthorCell.h"
#import "ONEUserItem.h"

#define kNumPerPage 3

static NSString *const cellID = @"ONEAllHotAuthorCell";

@interface ONEAllHotAuthorView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@property (assign, nonatomic) NSInteger lastItemIndex;

@end

@implementation ONEAllHotAuthorView

+ (instancetype)hotAuthorView {
    ONEAllHotAuthorView *hotAuthorView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    return hotAuthorView;
}

//- (void)setFrame:(CGRect)frame {
//    frame.size.height = frame.size.height - 8;
//    [super setFrame:frame];
//}

- (void)setHotAuthorList:(NSArray *)hotAuthorList {
    _hotAuthorList = hotAuthorList;
    [self.tableView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONEAllHotAuthorCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    
    self.changeButton.layer.borderWidth = 1;
    self.changeButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.changeButton.layer.cornerRadius = 2;
}

- (IBAction)changeButtonClick:(UIButton *)sender {
    self.lastItemIndex += kNumPerPage;
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumPerPage;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONEAllHotAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSInteger index = (self.hotAuthorList.count != 0) ? (self.lastItemIndex + indexPath.row)%(self.hotAuthorList.count) : 0;
    ONEUserItem *authorItem = self.hotAuthorList[index];
    
    cell.authorItem = authorItem;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
