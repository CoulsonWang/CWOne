//
//  CWScrollView.h
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 分页标签位置枚举
typedef enum : NSUInteger {
    CWPageControlPostionBottomLeft,
    CWPageControlPostionBottomRight,
    CWPageControlPostionBottomMiddel,
    CWPageControlPostionTopLeft,
    CWPageControlPostionTopRight,
    CWPageControlPostionTopMiddel,
} CWPageControlPostion;

// 滚动方向
typedef enum : NSUInteger {
    CWScrollDirectionRight,
    CWScrollDirectionDown,
    CWScrollDirectionLeft,
    CWScrollDirectionUp
} CWScrollDirection;

@class CWCarouselView;

@protocol CWCarouselViewDelegate <NSObject>
- (void)carouselView:(CWCarouselView *)carouselView didClickImageOnIndex:(NSUInteger)index;

@end

@interface CWCarouselView : UIView

/**
 显示的图片数组
 */
@property (copy, nonatomic) NSArray<UIImage *> *imageGroup;
/**
 所有图片的URL地址
 */
@property (copy, nonatomic) NSArray<NSURL *> *imageUrls;

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>处理点击事件用到的属性>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
/**
 点击图片时执行的操作数组，若只传入一个操作，则点击所有图片均执行该操作
 */
@property (copy, nonatomic) NSArray<void (^)()> *operations;
/**
 代理,用于处理图片点击事件。设置代理后，传入的block将会失效
 */
@property (weak, nonatomic) id<CWCarouselViewDelegate> delegate;


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>所有自定义属性>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */

/**
 轮播间隔
 */
@property (assign, nonatomic) NSTimeInterval interval;

/**
 轮播动画的动画时长
 */
@property (assign, nonatomic) NSTimeInterval scrollAnimationDuration;
/**
 占位图片
 */
@property (strong, nonatomic) UIImage *placeholderImage;
/**
 图片填充模式
 */
@property (assign, nonatomic) UIViewContentMode imageContentMode;
/**
 是否允许拖动
 */
@property (assign, nonatomic, getter=isAllowDragging) BOOL allowDragging;

/**
 自动滚动时的滚动方向
 */
@property (assign, nonatomic) CWScrollDirection scrollDirection;
/*>>>>>>>>>>>>>>自定义pageControl的属性>>>>>>>>>>>>>>>>>>>>>> */

/**
 分页标签是否可见
 */
@property (assign, nonatomic, getter=isPageControlVisible) BOOL pageControlVisible;
/**
 设置pageControl的位置
 */
@property (assign, nonatomic) CWPageControlPostion pageControlPostion;
/**
 分页标签的主题色
 */
@property (strong, nonatomic) UIColor *pageIndicatorTintColor;
/**
 当前分页的主题色
 */
@property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;






- (instancetype)initWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup;

+ (instancetype)carouselViewWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup;

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray<NSURL *> *)imageUrls placeholder:(UIImage *)placeholder;

+ (instancetype)carouselViewWithFrame:(CGRect)frame imageUrls:(NSArray<NSURL *> *)imageUrls placeholder:(UIImage *)placeholder;


@end
