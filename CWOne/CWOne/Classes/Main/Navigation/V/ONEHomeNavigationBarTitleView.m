//
//  ONEHomeNavigationBarTitleView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeNavigationBarTitleView.h"
#import "ONEHomeWeatherItem.h"
#import "NSString+ONEComponents.h"

#define kMaxTitleY 20.0
#define kMinTitleY 0.0
#define kBackBtnCenterYOffset 10.0
#define kMaxBackBtnCenterY kNavigationBarHeight * 0.5 + kBackBtnCenterYOffset
#define kMinBackBtnCenterY kNavigationBarHeight * 0.5

@interface ONEHomeNavigationBarTitleView ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *backToTodayButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (assign, nonatomic, getter=isUnfold) BOOL unfold;

@end

@implementation ONEHomeNavigationBarTitleView

+ (instancetype)homeNavTitleView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleButton.frame = CGRectMake(0, kMaxTitleY, CWScreenW, kNavigationBarHeight - 20.0);
    self.weatherLabel.centerX = CWScreenW * 0.5;
    self.searchButton.x = CWScreenW - self.searchButton.width;
}

- (void)setWeatherItem:(ONEHomeWeatherItem *)weatherItem {
    _weatherItem = weatherItem;
    
    NSDateComponents *components = [weatherItem.date getComponents];
    
    NSString *title = [NSString stringWithFormat:@"%ld    /    %02zd    /    %02zd",components.year,components.month,components.day];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    
    NSString *weatherStr = [NSString stringWithFormat:@"%@     %@     %@°C",weatherItem.city_name,weatherItem.climate,weatherItem.temperature];
    self.weatherLabel.text = weatherStr;
}

#pragma mark - 事件响应
- (IBAction)titleButtonClick:(UIButton *)sender {
    
    self.unfold = !self.isUnfold;
    
    if(self.unfold) {
        [UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(radian(-179.9));
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

- (IBAction)searchButtonClick:(UIButton *)sender {
    
}
- (IBAction)backToTodayButtonClick:(UIButton *)sender {
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ONETitleViewBackToTodayButtonClickNotifcation object:nil userInfo:nil];
}

#pragma mark - 对外方法
- (void)updateSubFrameAndAlphaWithOffset:(CGFloat)offset {
    // 修改搜索按钮的alpha
    self.searchButton.alpha = (offset/ONEScrollOffsetLimit);
    // 修改箭头的alpha
    self.arrowImageView.alpha = (offset/ONEScrollOffsetLimit);
    // 修改天气标签的alpha
    self.weatherLabel.alpha = 1-offset/ONEScrollOffsetLimit;
    
    
    // 修改title的frame
    CGFloat titleY = kMinTitleY + kMaxTitleY * (offset/ONEScrollOffsetLimit);
    titleY = titleY < kMinTitleY ? kMinTitleY : titleY;
    titleY = titleY > kMaxTitleY ? kMaxTitleY : titleY;
    self.titleButton.y = titleY;
    // 修改返回标签的frame
    CGFloat backCenterY = kMinBackBtnCenterY + kBackBtnCenterYOffset * (offset/ONEScrollOffsetLimit);
    backCenterY = backCenterY < kMinBackBtnCenterY ? kMinBackBtnCenterY : backCenterY;
    backCenterY = backCenterY > kMaxBackBtnCenterY ? kMaxBackBtnCenterY : backCenterY;
    self.backToTodayButton.centerY = backCenterY;
}

- (void)enableTheTitleButton:(BOOL)isEnable {
    self.titleButton.enabled = isEnable;
}

- (void)updateBackButtonVisible:(BOOL)isHidden {
    self.backToTodayButton.hidden = isHidden;
}




@end
