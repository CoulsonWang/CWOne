//
//  ONEDetailMovieInfoController.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/9.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailMovieInfoController.h"
#import <UIImageView+WebCache.h>
#import "ONEEssayItem.h"
#import "UILabel+CWLineSpacing.h"
#import "ONENavigationBarTool.h"

#define kSideMargin 45

@interface ONEDetailMovieInfoController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) UIImageView *postView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *summaryLabel;
@property (weak, nonatomic) UILabel *movieInfoLabel;
@property (weak, nonatomic) UILabel *introducTitleLabel;
@property (weak, nonatomic) UILabel *officialStoryLabel;

@end

@implementation ONEDetailMovieInfoController

#pragma mark - 懒加载
- (UIImageView *)postView {
    if (!_postView) {
        UIImageView *postView = [[UIImageView alloc] init];
        [self.scrollView addSubview:postView];
        postView.frame = CGRectMake(0, 100, 175, 250);
        postView.centerX = CWScreenW * 0.5;
        _postView = postView;
    }
    return _postView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.scrollView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:19];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)summaryLabel {
    if (!_summaryLabel) {
        UILabel *summaryLabel = [[UILabel alloc] init];
        [self.scrollView addSubview:summaryLabel];
        summaryLabel.font = [UIFont systemFontOfSize:14];
        summaryLabel.textAlignment = NSTextAlignmentCenter;
        summaryLabel.textColor = [UIColor colorWithWhite:30/255.0 alpha:1.0];
        _summaryLabel = summaryLabel;
    }
    return _summaryLabel;
}

- (UILabel *)movieInfoLabel {
    if (!_movieInfoLabel) {
        UILabel *movieInfoLabel = [[UILabel alloc] init];
        [self.scrollView addSubview:movieInfoLabel];
        movieInfoLabel.font = [UIFont systemFontOfSize:12.5];
        movieInfoLabel.textColor = [UIColor colorWithWhite:140/255.0 alpha:1.0];
        movieInfoLabel.textAlignment = NSTextAlignmentCenter;
        movieInfoLabel.numberOfLines = 0;
        _movieInfoLabel = movieInfoLabel;
    }
    return _movieInfoLabel;
}

- (UILabel *)introducTitleLabel {
    if (!_introducTitleLabel) {
        UILabel *introducTitleLabel = [[UILabel alloc] init];
        [self.scrollView addSubview:introducTitleLabel];
        introducTitleLabel.font = [UIFont systemFontOfSize:12.5];
        introducTitleLabel.textColor = [UIColor colorWithWhite:140/255.0 alpha:1.0];
        introducTitleLabel.textAlignment = NSTextAlignmentCenter;
        introducTitleLabel.text = @"—— 剧情简介 ——";
        _introducTitleLabel = introducTitleLabel;
    }
    return _introducTitleLabel;
}

- (UILabel *)officialStoryLabel {
    if (!_officialStoryLabel) {
        UILabel *officialStoryLabel = [[UILabel alloc] init];
        [self.scrollView addSubview:officialStoryLabel];
        officialStoryLabel.numberOfLines = 0;
        officialStoryLabel.font = [UIFont systemFontOfSize:14];
        _officialStoryLabel = officialStoryLabel;
    }
    return _officialStoryLabel;
}

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
    
    NSURL *posterURL = [NSURL URLWithString:_essayItem.poster];
    [self.postView sd_setImageWithURL:posterURL];
    
    self.titleLabel.text = _essayItem.movieTitle;
    [self updateLableFrame:self.titleLabel withTopOffset:22 toView:self.postView];
    
    self.summaryLabel.text = _essayItem.summary;
    [self updateLableFrame:self.summaryLabel withTopOffset:20 toView:self.titleLabel];
    
    [self.movieInfoLabel setText:_essayItem.info lineSpacing:10.0];
    [self updateLableFrame:self.movieInfoLabel withTopOffset:30 toView:self.summaryLabel];
    
    [self updateLableFrame:self.introducTitleLabel withTopOffset:45 toView:self.movieInfoLabel];
    
    
    [self.officialStoryLabel setText:[NSString stringWithFormat:@"  %@",_essayItem.officialstory] lineSpacing:12.0];
    [self setUpOfficialStoryLabel];
    
    CGFloat sizeHeight = CGRectGetMaxY(self.officialStoryLabel.frame) + 100;
    self.scrollView.contentSize = CGSizeMake(0, sizeHeight);
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

- (void)setupScrollView {
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitTheDetailView)]];
}

- (IBAction)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
                                          
- (void)quitTheDetailView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateLableFrame:(UILabel *)label withTopOffset:(CGFloat)topOffset toView:(UIView *)lastView {
    [label sizeToFit];
    label.y = CGRectGetMaxY(lastView.frame) + topOffset;
    label.centerX = CWScreenW * 0.5;
}

- (void)setUpOfficialStoryLabel {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:12.0];
    
    CGRect rect = [_essayItem.officialstory boundingRectWithSize:CGSizeMake(CWScreenW - 2*kSideMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.officialStoryLabel.font,NSParagraphStyleAttributeName : paragraphStyle} context:nil];
    
    self.officialStoryLabel.width = rect.size.width;
    self.officialStoryLabel.height = rect.size.height;
    self.officialStoryLabel.y = CGRectGetMaxY(self.introducTitleLabel.frame) + 20;
    self.officialStoryLabel.centerX = CWScreenW * 0.5;
}

@end
