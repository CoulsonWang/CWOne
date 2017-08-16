//
//  ONEHomeFeedDatePickerView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ONEDatePickerViewPositionTop,
    ONEDatePickerViewPositionBottom,
} ONEDatePickerViewPosition;

@class ONEHomeFeedDatePickerView;

@protocol ONEHomeFeedDatePickerViewDelegate <NSObject>

- (void)feedDataPicker:(ONEHomeFeedDatePickerView *)feedDatePickerView didConfirmSelectedWithDateString:(NSString *)dateString;

@end

@interface ONEHomeFeedDatePickerView : UIView

@property (weak, nonatomic) id<ONEHomeFeedDatePickerViewDelegate> delegate;

+ (instancetype)datePickerViewWithPosition:(ONEDatePickerViewPosition)postion frame:(CGRect)frame;

- (void)appearWithDateString:(NSString *)dateString;

@end
