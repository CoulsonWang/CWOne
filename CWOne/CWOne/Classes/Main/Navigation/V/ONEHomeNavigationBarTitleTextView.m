//
//  ONEHomeNavigationBarTitleTextView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/5.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeNavigationBarTitleTextView.h"
#import "CWCalendarLabel.h"
#import "NSString+ONEComponents.h"

#define kYearLabelWidth 80.0
#define kLabelWidth 60.0
#define kLabelHeight 25.0
#define kSlashWidth 10

@interface ONEHomeNavigationBarTitleTextView ()

@property (weak, nonatomic) CWCalendarLabel *yearLabel;
@property (weak, nonatomic) CWCalendarLabel *monthLabel;
@property (weak, nonatomic) CWCalendarLabel *dayLabel;
@property (weak, nonatomic) UILabel *leftSlashLabel;
@property (weak, nonatomic) UILabel *rightSlashLabel;

@end

@implementation ONEHomeNavigationBarTitleTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpLabels];
    }
    return self;
}

- (void)setUpLabels {
    CWCalendarLabel *monthLabel = [[CWCalendarLabel alloc] init];
    monthLabel.bounds = CGRectMake(0, 0, kLabelWidth, kLabelHeight);
    [self addSubview:monthLabel];
    self.monthLabel = monthLabel;
    
    UILabel *leftSlash = [[UILabel alloc] init];
    leftSlash.bounds = CGRectMake(0,0,kSlashWidth,kLabelHeight);
    [self addSubview:leftSlash];
    self.leftSlashLabel = leftSlash;
    
    CWCalendarLabel *yearLabel = [[CWCalendarLabel alloc] init];
    yearLabel.bounds = CGRectMake(0, 0, kYearLabelWidth, kLabelHeight);
    [self addSubview:yearLabel];
    self.yearLabel = yearLabel;
    
    UILabel *rightSlash = [[UILabel alloc] init];
    rightSlash.bounds = CGRectMake(0,0,kSlashWidth,kLabelHeight);
    [self addSubview:rightSlash];
    self.rightSlashLabel = rightSlash;
    
    CWCalendarLabel *dayLabel = [[CWCalendarLabel alloc] init];
    dayLabel.bounds = CGRectMake(0, 0, kLabelWidth, kLabelHeight);
    [self addSubview:dayLabel];
    self.dayLabel = dayLabel;
    
    [self setUpOneLabelsProperty:self.monthLabel];
    [self setUpOneLabelsProperty:self.yearLabel];
    [self setUpOneLabelsProperty:self.dayLabel];
    [self setUpOneLabelsProperty:self.leftSlashLabel];
    [self setUpOneLabelsProperty:self.rightSlashLabel];
}

- (void)setUpOneLabelsProperty:(UILabel *)label {
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:ONEThemeFontName size:22];
    if ([label isKindOfClass:[CWCalendarLabel class]]) {
        CWCalendarLabel *calendarLabel = (CWCalendarLabel *)label;
        calendarLabel.animateDuration = 0.35;
        calendarLabel.enableWhenSame = NO;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.monthLabel.center = CGPointMake(self.width * 0.5 + 8, self.height * 0.5);
    self.leftSlashLabel.centerY = self.height * 0.5;
    self.leftSlashLabel.x = self.monthLabel.x - kSlashWidth;
    self.yearLabel.centerY = self.height * 0.5;
    self.yearLabel.x = self.leftSlashLabel.x - kYearLabelWidth;
    self.rightSlashLabel.centerY = self.height * 0.5;
    self.rightSlashLabel.x = CGRectGetMaxX(self.monthLabel.frame);
    self.dayLabel.centerY = self.height * 0.5;
    self.dayLabel.x = CGRectGetMaxX(self.rightSlashLabel.frame);
}


- (void)setDateString:(NSString *)dateString {
    NSDateComponents *components = [dateString getComponents];
    NSString *yearStr = [NSString stringWithFormat:@"%ld",components.year];
    NSString *monthStr = [NSString stringWithFormat:@"%02ld",components.month];
    NSString *dayStr = [NSString stringWithFormat:@"%02ld",components.day];
    
    self.leftSlashLabel.text = @"/";
    self.rightSlashLabel.text = @"/";
    // 仅赋值，不做动画
    if (_dateString == nil) {
        self.yearLabel.text = yearStr;
        self.monthLabel.text = monthStr;
        self.dayLabel.text = dayStr;
    } else {
        CWCalendarLabelScrollDirection direction = [_dateString isLaterThanAnotherDateString:dateString] ? CWCalendarLabelScrollToTop : CWCalendarLabelScrollToBottom;
        [self.yearLabel showNextText:yearStr withDirection:direction];
        [self.monthLabel showNextText:monthStr withDirection:direction];
        [self.dayLabel showNextText:dayStr withDirection:direction];
    }
    _dateString = dateString;
}

@end
