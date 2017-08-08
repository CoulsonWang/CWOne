//
//  CWCalendarLabel.m
//  CWCalendarLabel
//
//  Created by Coulson_Wang on 2017/8/5.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "CWCalendarLabel.h"

#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height

typedef enum : NSUInteger {
    CWCalendarLabelPositionCenter,
    CWCalendarLabelPositionTop,
    CWCalendarLabelPositionBottom,
} CWCalendarLabelPosition;

@interface CWCalendarLabel ()


// 记录是否正在播放动画
@property (assign, nonatomic, getter=isAnimating) BOOL animating;

@property (assign, nonatomic) NSInteger animCount;

@property (strong, nonatomic) NSMutableArray<UILabel *> *animLables;

@property (strong, nonatomic) NSString *lastText;

@end

@implementation CWCalendarLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animateDuration = 0.5;
        self.animCount = 0;
        self.animLables = [NSMutableArray array];
        self.enableWhenSame = YES;
    }
    return self;
}

- (NSString *)lastText {
    if (!_lastText) {
        _lastText = self.text;
    }
    return _lastText;
}

- (BOOL)isAnimating {
    return (self.animLables.count != 0);
}


// 核心方法
- (void)showNextText:(NSString *)nextText withDirection:(CWCalendarLabelScrollDirection)direction {
    
    [self removeAllAnimate];
    
    if ([self.text isEqualToString:nextText] && !self.isEnableWhenSame) {
        return;
    }
    
    CWCalendarLabelPosition nextPosition = (direction == CWCalendarLabelScrollToTop) ? CWCalendarLabelPositionBottom : CWCalendarLabelPositionTop;
    UILabel *nextLabel = [self addNextTextLabelWithText:nextText atPosition:nextPosition];
    UILabel *currentLabel = [self addNextTextLabelWithText:self.lastText atPosition:CWCalendarLabelPositionCenter];
    CGFloat translantionY = (nextPosition == CWCalendarLabelPositionTop) ? kHeight : -kHeight;
    
    self.lastText = nextText;
    
    [UIView animateWithDuration:self.animateDuration animations:^{
        currentLabel.transform = CGAffineTransformMakeTranslation(0, translantionY);
        currentLabel.alpha = 0;
        self.hidden = YES;
        nextLabel.transform = CGAffineTransformMakeTranslation(0, translantionY);
        nextLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.text = nextText;
        [self removeAnimLable:nextLabel];
        [self removeAnimLable:currentLabel];
        if (!self.animating) {
            self.hidden = NO;
        }
    }];
}

#pragma mark - 私有工具方法
// 在父控件上添加一个lable实现动画
- (UILabel *)addNextTextLabelWithText:(NSString *)text atPosition:(CWCalendarLabelPosition)position {
    CGFloat y;
    switch (position) {
        case CWCalendarLabelPositionTop:
            y = self.frame.origin.y - kHeight - self.distance;
            break;
        case CWCalendarLabelPositionBottom:
            y = self.frame.origin.y + kHeight + self.distance;
            break;
        case CWCalendarLabelPositionCenter:
            y = self.frame.origin.y;
            break;
        default:
            break;
    }
    UILabel *animLabel = [[UILabel alloc] init];
    animLabel.text = text;
    [self setUpNextTextLabel:animLabel];
    animLabel.alpha = (position == CWCalendarLabelPositionCenter) ? 1 : 0;
    
    if (self.isSizeToFitOn) {
        [animLabel sizeToFit];
        // 修改宽度
        CGFloat width = animLabel.bounds.size.width;
        CGFloat x;
        if (self.textAlignment == NSTextAlignmentLeft) {
            x = self.frame.origin.x;
        } else if (self.textAlignment == NSTextAlignmentRight) {
            x = self.frame.origin.x + kWidth - width;
        } else {
            x = self.frame.origin.x + (kWidth - width) * 0.5;
        }
        animLabel.frame = CGRectMake(x, y, width, kHeight);
    } else {
        animLabel.frame = CGRectMake(self.frame.origin.x, y, kWidth, kHeight);
    }
    
    
    [self.superview addSubview:animLabel];
    [self.animLables addObject:animLabel];
    
    return animLabel;
}

// 设置临时文本控件的样式
- (void)setUpNextTextLabel:(UILabel *)label {
    label.textColor = self.textColor;
    label.font = self.font;
    label.textAlignment = self.textAlignment;
    label.numberOfLines = self.numberOfLines;
}
     
- (void)removeAnimLable:(UILabel *)animLable {
     [self.animLables removeObject:animLable];
     [animLable removeFromSuperview];
 }

- (void)removeAllAnimate {
    for (UILabel *lable in self.animLables) {
        [lable removeFromSuperview];
    }
    [self.animLables removeAllObjects];
}

@end
