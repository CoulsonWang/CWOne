//
//  CWCalendarLabel.h
//  CWCalendarLabel
//
//  Created by Coulson_Wang on 2017/8/5.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CWCalendarLabelScrollToTop,
    CWCalendarLabelScrollToBottom,
} CWCalendarLabelScrollDirection;

@interface CWCalendarLabel : UILabel


/**
 核心方法，播放滚动动画

 @param nextText 新的文本
 @param direction 滚动方向
 */
- (void)showNextText:(NSString *)nextText withDirection:(CWCalendarLabelScrollDirection)direction;

/// 以下为可以自定义的属性

// 动画播放时长，默认为0.5
@property (assign, nonatomic) NSTimeInterval animateDuration;

// 动画label与原label之间的额外垂直间距，默认为0(紧贴)
@property (assign, nonatomic) CGFloat distance;


@end
