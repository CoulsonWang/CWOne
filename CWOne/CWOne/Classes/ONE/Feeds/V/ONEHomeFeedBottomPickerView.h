//
//  ONEHomeFeedBottomPickerView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeFeedBottomPickerView;

@protocol ONEHomeFeedBottomPickerViewDelegate <NSObject>

- (void)feedDatePickViewDidClick:(ONEHomeFeedBottomPickerView *)pickView;

@end

@interface ONEHomeFeedBottomPickerView : UIView

@property (strong, nonatomic) NSString *dateString;

@property (weak, nonatomic) id<ONEHomeFeedBottomPickerViewDelegate> delegate;

@end
