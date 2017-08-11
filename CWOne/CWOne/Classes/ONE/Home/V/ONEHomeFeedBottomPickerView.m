//
//  ONEHomeFeedBottomPickerView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeFeedBottomPickerView.h"
#import "CWCalendarLabel.h"
#import "NSString+ONEComponents.h"

#define kMargin 8.0

@interface ONEHomeFeedBottomPickerView ()

@property (weak, nonatomic) CWCalendarLabel *yearNumLabel;
@property (weak, nonatomic) CWCalendarLabel *monthNumLabel;

@end

@implementation ONEHomeFeedBottomPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllSubViews];
    }
    return self;
}

- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    
    NSDateComponents *components = [dateString getComponents];
    self.yearNumLabel.text = [NSString stringWithFormat:@"%ld",components.year];
    self.monthNumLabel.text = [NSString stringWithFormat:@"%ld",components.month];
}

- (void)addAllSubViews {
    self.backgroundColor = [UIColor colorWithWhite:251/255.0 alpha:1.0];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPicker)]];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, 1)];
    seperatorView.backgroundColor = [UIColor colorWithWhite:244/255.0 alpha:1.0];
    [self addSubview:seperatorView];
    
    CWCalendarLabel *yearNumLabel = [[CWCalendarLabel alloc] init];
    yearNumLabel.font = [UIFont systemFontOfSize:13];
    yearNumLabel.textColor = [UIColor colorWithWhite:150/255.0 alpha:1.0];
    yearNumLabel.enableWhenSame = NO;
    yearNumLabel.sizeToFitOn = YES;
    yearNumLabel.textAlignment = NSTextAlignmentCenter;
    yearNumLabel.frame = CGRectMake(self.width * 0.5 - 60, 0, 30, 15);
    yearNumLabel.centerY = self.height * 0.5;
    [self addSubview:yearNumLabel];
    self.yearNumLabel = yearNumLabel;
    
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.font = [UIFont systemFontOfSize:13];
    yearLabel.textColor = [UIColor colorWithWhite:150/255.0 alpha:1.0];
    yearLabel.text = @"年";
    [yearLabel sizeToFit];
    yearLabel.centerY = self.height * 0.5;
    yearLabel.x = CGRectGetMaxX(yearNumLabel.frame) + kMargin;
    [self addSubview:yearLabel];
    
    CWCalendarLabel *monthNumLabel = [[CWCalendarLabel alloc] init];
    monthNumLabel.font = [UIFont systemFontOfSize:13];
    monthNumLabel.textColor = [UIColor colorWithWhite:150/255.0 alpha:1.0];
    monthNumLabel.enableWhenSame = NO;
    monthNumLabel.sizeToFitOn = YES;
    monthNumLabel.textAlignment = NSTextAlignmentCenter;
    monthNumLabel.frame = CGRectMake(CGRectGetMaxX(yearLabel.frame) + kMargin, 0, 12, 15);
    monthNumLabel.centerY = self.height * 0.5;
    [self addSubview:monthNumLabel];
    self.monthNumLabel = monthNumLabel;
    
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.font = [UIFont systemFontOfSize:13];
    monthLabel.textColor = [UIColor colorWithWhite:150/255.0 alpha:1.0];
    monthLabel.text = @"月";
    [monthLabel sizeToFit];
    monthLabel.x = CGRectGetMaxX(monthNumLabel.frame) + kMargin;
    monthLabel.centerY = self.height * 0.5;
    [self addSubview:monthLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
    [arrowView sizeToFit];
    arrowView.centerY = self.height * 0.5;
    arrowView.x = self.width * 0.5 + 50;
    [self addSubview:arrowView];
    
}

- (void)didTapPicker {
    
}

@end
