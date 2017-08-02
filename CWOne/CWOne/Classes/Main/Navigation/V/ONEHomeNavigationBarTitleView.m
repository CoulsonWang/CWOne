//
//  ONEHomeNavigationBarTitleView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeNavigationBarTitleView.h"
#import "ONEHomeWeatherItem.h"

@interface ONEHomeNavigationBarTitleView ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *backToTodayButton;

@property (assign, nonatomic, getter=isUnfold) BOOL unfold;

@end

@implementation ONEHomeNavigationBarTitleView

+ (instancetype)homeNavTitleView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

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

- (void)setWeatherItem:(ONEHomeWeatherItem *)weatherItem {
    _weatherItem = weatherItem;
    
    NSDateComponents *components = [self getComponentsByDateString:weatherItem.date];
    
    NSString *title = [NSString stringWithFormat:@"%ld    /    %02zd    /    %02zd",components.year,components.month,components.day];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}


- (IBAction)searchButtonClick:(UIButton *)sender {
}

#pragma mark - 私有方法
- (NSDateComponents *)getComponentsByDateString:(NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:dateString];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
}

@end
