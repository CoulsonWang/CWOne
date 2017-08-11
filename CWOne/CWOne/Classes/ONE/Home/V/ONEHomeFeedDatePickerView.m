//
//  ONEHomeFeedDatePickerView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeFeedDatePickerView.h"

#define kInfoLabelHeight 35
#define kConfirmButtonHeight 48
#define kAnimationDuration 0.3
#define kTotalBottomHeight  220
#define kPickerHeight kTotalBottomHeight - kInfoLabelHeight - kConfirmButtonHeight

#define kYearKey @"year"
#define kMonthsKey @"months"

@interface ONEHomeFeedDatePickerView () <UIPickerViewDataSource ,UIPickerViewDelegate>

@property (weak, nonatomic) UIView *backgroundView;

@property (weak, nonatomic) UIView *totalBottomView;
@property (weak, nonatomic) UILabel *infoLabel;
@property (weak, nonatomic) UIPickerView *datePicker;
@property (weak, nonatomic) UIButton *confirmButton;

@property (strong, nonatomic) NSArray<NSDictionary *> *yearArray;

@end

@implementation ONEHomeFeedDatePickerView

#pragma mark - 懒加载
- (NSArray<NSDictionary *> *)yearArray {
    if (!_yearArray) {
        NSMutableArray<NSDictionary *> *yearArray = [NSMutableArray array];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
        
        NSMutableArray *monthOfCurrentYear = [NSMutableArray array];
        for (NSInteger i = components.month; i > 0; i--) {
            [monthOfCurrentYear addObject:[NSNumber numberWithInteger:i]];
        }
        NSDictionary *dictForCurrentYear = @{kYearKey:[NSString stringWithFormat:@"%ld",components.year],kMonthsKey:monthOfCurrentYear};
        [yearArray addObject:dictForCurrentYear];
        
        for (NSInteger i = components.year - 1; i > 2012 ; i--) {
            NSArray *month = @[@12,@11,@10,@9,@8,@7,@6,@5,@4,@3,@2,@1];
            NSDictionary *dict = @{kYearKey:[NSString stringWithFormat:@"%ld",i],kMonthsKey:month};
            [yearArray addObject:dict];
        }
        
        NSArray *monthOf2012 = @[@12,@11,@10];
        NSDictionary *dictFor2012 = @{kYearKey:@"2012",kMonthsKey:monthOf2012};
        [yearArray addObject:dictFor2012];
        
        _yearArray = yearArray;
    }
    return _yearArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CWScreenW, CWScreenH)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideThePickerView)]];
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    UIView *totalBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CWScreenH, CWScreenW , kTotalBottomHeight)];
    totalBottomView.backgroundColor = [UIColor colorWithWhite:251/255.0 alpha:1.0];
    [self addSubview:totalBottomView];
    self.totalBottomView = totalBottomView;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"选择日期";
    infoLabel.frame = CGRectMake(0, 0, CWScreenW, kInfoLabelHeight);
    infoLabel.font = [UIFont systemFontOfSize:13];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor colorWithWhite:137/255.0 alpha:1.0];
    [totalBottomView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kInfoLabelHeight, CWScreenW, kPickerHeight)];
    picker.dataSource = self;
    picker.delegate = self;
    [totalBottomView addSubview:picker];
    self.datePicker = picker;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, kTotalBottomHeight - kConfirmButtonHeight - 0.5, CWScreenW, 0.5)];
    seperatorView.backgroundColor = [UIColor colorWithWhite:241/255.0 alpha:1.0];
    [totalBottomView addSubview:seperatorView];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kTotalBottomHeight - kConfirmButtonHeight, CWScreenW, kConfirmButtonHeight)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithWhite:78/255.0 alpha:1.0] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [confirmButton addTarget:self action:@selector(confirmSelected) forControlEvents:UIControlEventTouchUpInside];
    [totalBottomView addSubview:confirmButton];
    self.confirmButton = confirmButton;
}

- (void)hideThePickerView {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.alpha = 0;
        self.totalBottomView.y = CWScreenH;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)confirmSelected {
    NSInteger yearIndex = [self.datePicker selectedRowInComponent:0];
    NSInteger year = [self.yearArray[yearIndex][kYearKey] integerValue];
    
    NSInteger monthIndex = [self.datePicker selectedRowInComponent:1];
    NSArray *months = self.yearArray[yearIndex][kMonthsKey];
    NSInteger month = [months[monthIndex] integerValue];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld",year,month];
    [self.delegate feedDataPicker:self didConfirmSelectedWithDateString:dateString];
    [self hideThePickerView];
}

#pragma mark - 对外方法
- (void)appear {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.alpha = 0.5;
        self.totalBottomView.y = CWScreenH - kTotalBottomHeight;
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArray.count;
    } else {
        NSDictionary *yearDict = self.yearArray[[pickerView selectedRowInComponent:0]];
        NSArray *monthArray = yearDict[kMonthsKey];
        return monthArray.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSString *year = self.yearArray[row][kYearKey];
        NSString *yearStr = [NSString stringWithFormat:@"%@年",year];
        return yearStr;
    } else {
        NSDictionary *yearDict = self.yearArray[[pickerView selectedRowInComponent:0]];
        NSArray *months = yearDict[kMonthsKey];
        NSString *monthStr = [NSString stringWithFormat:@"%@月",months[row]];
        return monthStr;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    
    if (label == nil) {
        label = [[UILabel alloc]init];
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithWhite:165/255.0 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return label;
}

@end
