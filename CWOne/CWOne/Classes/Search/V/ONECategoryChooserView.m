//
//  ONECategoryChooserView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONECategoryChooserView.h"
#import "ONECategoryChooserViewCell.h"

#define kCategoryArray @[@"图文",@"问答",@"阅读",@"连载",@"影视",@"音乐",@"电台"]
#define kRowHeight 50.0
#define kAnimationDuration 0.3

static NSString *const cellID = @"ONECategoryChooserViewCell";

@interface ONECategoryChooserView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UIView *backgroundView;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation ONECategoryChooserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.clipsToBounds = YES;
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideChooserView)]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, kCategoryArray.count * kRowHeight)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kRowHeight;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ONECategoryChooserViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    tableView.hidden = YES;
    [self addSubview:tableView];
    self.tableView = tableView;
}

- (void)showChooserView {
    self.tableView.hidden = NO;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.alpha = 0.5;
    }];
}

- (void)hideChooserView {
    [self.delegate categoryChooserViewDidCancleChoose:self];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.tableView.y = -self.tableView.height;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kCategoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ONECategoryChooserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.categoryName = kCategoryArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index;
    switch (indexPath.row) {
        case 0:
            index = 0;
            break;
        case 1:
            index = 3;
            break;
        case 2:
            index = 1;
            break;
        case 3:
            index = 2;
            break;
        case 4:
            index = 5;
            break;
        case 5:
            index = 4;
            break;
        case 6:
            index = 8;
            break;
        default:
            index = -1;
            break;
    }
    [self.delegate categoryChooserView:self didChooseAtIndex:index];
}

@end
