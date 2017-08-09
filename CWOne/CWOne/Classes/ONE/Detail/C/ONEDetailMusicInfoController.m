//
//  ONEDetailMusicInfoController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/9.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailMusicInfoController.h"
#import "ONEEssayItem.h"
#import <UIImageView+WebCache.h>
#import "UILabel+CWLineSpacing.h"
#import "ONENavigationBarTool.h"

#define kLineSpacing 10.0
#define kSideMargin 45

@interface ONEDetailMusicInfoController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) UIScrollView *lrcScrollView;
@property (weak, nonatomic) UILabel *lrcLabel;

@property (weak, nonatomic) UIScrollView *musicInfoScrollView;
@property (weak, nonatomic) UIImageView *musicCoverView;
@property (weak, nonatomic) UILabel *musicInfoLabel;

@end

@implementation ONEDetailMusicInfoController

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpPageScrollView];
    
    [self setUpLrcScrollView];
    
    [self setUpMusicInfoScrollView];
    
    [self loadData];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitTheDetailView)]];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 隐藏statusBar
    [[ONENavigationBarTool sharedInstance] hideStatusBarWithAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复statusBar的显示
    [[ONENavigationBarTool sharedInstance] resumeStatusBarWithAnimated:YES];
}

#pragma mark - 初始化UI
- (void)setUpPageScrollView {
    self.pageScrollView.contentSize = CGSizeMake(CWScreenW * 2, 0);
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.delegate = self;
}

- (void)setUpLrcScrollView {
    UIScrollView *lrcScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pageScrollView.width, self.pageScrollView.height)];
    lrcScrollView.showsVerticalScrollIndicator = NO;
    [self.pageScrollView addSubview:lrcScrollView];
    self.lrcScrollView = lrcScrollView;
    
    UILabel *lrcLabel = [[UILabel alloc] init];
    [lrcScrollView addSubview:lrcLabel];
    lrcLabel.font = [UIFont systemFontOfSize:14];
    lrcLabel.textColor = [UIColor colorWithWhite:80/255.0 alpha:1.0];
    lrcLabel.textAlignment = NSTextAlignmentCenter;
    lrcLabel.numberOfLines = 0;
    self.lrcLabel = lrcLabel;
}

- (void)setUpMusicInfoScrollView {
    UIScrollView *musicInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CWScreenW, 0, self.pageScrollView.width, self.pageScrollView.height)];
    musicInfoScrollView.showsVerticalScrollIndicator = NO;
    [self.pageScrollView addSubview:musicInfoScrollView];
    self.musicInfoScrollView = musicInfoScrollView;
    
    UIImageView *musicCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 120, 120)];
    musicCoverView.centerX = CWScreenW * 0.5;
    [musicInfoScrollView addSubview:musicCoverView];
    self.musicCoverView = musicCoverView;
    
    UILabel *musicInfoLabel = [[UILabel alloc] init];
    [musicInfoScrollView addSubview:musicInfoLabel];
    musicInfoLabel.font = [UIFont systemFontOfSize:14];
    musicInfoLabel.textColor = [UIColor colorWithWhite:80/255.0 alpha:1.0];
    musicInfoLabel.textAlignment = NSTextAlignmentCenter;
    musicInfoLabel.numberOfLines = 0;
    self.musicInfoLabel = musicInfoLabel;
}

- (void)loadData {
    NSURL *coverURL = [NSURL URLWithString:_essayItem.cover];
    [self.musicCoverView sd_setImageWithURL:coverURL];
    
    [self.lrcLabel setText:_essayItem.lyric lineSpacing:kLineSpacing];
    [self setUpLabel:self.lrcLabel withLineSpacing:kLineSpacing];
    self.lrcLabel.y = 40;
    CGFloat LrcSizeHeight = CGRectGetMaxY(self.lrcLabel.frame);
    self.lrcScrollView.contentSize = CGSizeMake(0, LrcSizeHeight);
    
    
    [self.musicInfoLabel setText:_essayItem.info lineSpacing:kLineSpacing];
    [self setUpLabel:self.musicInfoLabel withLineSpacing:kLineSpacing];
    self.musicInfoLabel.y = CGRectGetMaxY(self.musicCoverView.frame) + 30;
    CGFloat musicInfoSize = CGRectGetMaxY(self.musicInfoLabel.frame) + 100;
    self.musicInfoScrollView.contentSize = CGSizeMake(0, musicInfoSize);
}

#pragma mark - 事件响应
- (IBAction)segmentControlChangeValue:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    [self.pageScrollView setContentOffset:CGPointMake(index * CWScreenW, 0) animated:YES];
}
- (IBAction)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)quitTheDetailView {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setUpLabel:(UILabel *)label withLineSpacing:(CGFloat)lineSpacing {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(CWScreenW - 2*kSideMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font,NSParagraphStyleAttributeName : paragraphStyle} context:nil];
    
    label.width = rect.size.width;
    label.height = rect.size.height;
    label.centerX = CWScreenW * 0.5;
}
- (void)updateViewWithOffsetX:(CGFloat)offsetX {
    NSInteger index = offsetX/CWScreenW;
    self.segmentControl.selectedSegmentIndex = index;
    self.pageControl.currentPage = index;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    [self updateViewWithOffsetX:offsetX];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    [self updateViewWithOffsetX:offsetX];
}



@end
