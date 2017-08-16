//
//  CWScrollView.m
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "CWCarouselView.h"
#import "CWImageView.h"
#import "SDWebImageManager.h"
#import "UIView+CWFrame.h"

#define CWWidth self.bounds.size.width
#define CWHeight self.bounds.size.height

typedef enum : NSUInteger {
    CWNext,
    CWPrev
} CWScrollOption;

@interface CWCarouselView () <UIScrollViewDelegate>

@property (weak, nonatomic) CWImageView *prevImageView;
@property (weak, nonatomic) CWImageView *currentImageView;
@property (weak, nonatomic) CWImageView *nextImageView;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) NSUInteger currentImageIndex;
@property (assign, nonatomic, readonly) NSUInteger prevImageIndex;
@property (assign, nonatomic, readonly) NSUInteger nextImageIndex;

@property (weak, nonatomic) NSTimer *timer;

@end

@implementation CWCarouselView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _pageControlVisible = YES;
        _pageControlPostion = CWPageControlPostionBottomLeft;
        _scrollDirection = CWScrollDirectionRight;
        _scrollAnimationDuration = 0.5;
    }
    return self;
}

- (void)removeFromSuperview {
    [self.timer invalidate];
    self.timer = nil;
    [super removeFromSuperview];
}

#pragma mark - 构造方法
// 构造方法
- (instancetype)initWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup {
    self = [self initWithFrame:frame];
    self.imageGroup = imageGroup;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray<NSURL *> *)imageUrls placeholder:(UIImage *)placeholder {
    self = [self initWithFrame:frame];
    self.placeholderImage = placeholder;
    self.imageUrls = imageUrls;
    return self;
}

// 工厂方法
+ (instancetype)carouselViewWithFrame:(CGRect)frame imageGroup:(NSArray<UIImage *> *)imageGroup {
    return [[CWCarouselView alloc] initWithFrame:frame imageGroup:imageGroup];
}

+ (instancetype)carouselViewWithFrame:(CGRect)frame imageUrls:(NSArray<NSURL *> *)imageUrls placeholder:(UIImage *)placeholder {
    return [[CWCarouselView alloc] initWithFrame:frame imageUrls:imageUrls placeholder:placeholder];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self insertSubview:scrollView atIndex:0];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (CWImageView *)prevImageView {
    if (!_prevImageView) {
        CWImageView *leftImageView = [[CWImageView alloc] init];
        [self.scrollView addSubview:leftImageView];
        _prevImageView = leftImageView;
    }
    return _prevImageView;
}

- (CWImageView *)currentImageView {
    if (!_currentImageView) {
        CWImageView *middleImageView = [[CWImageView alloc] init];
        [self.scrollView addSubview:middleImageView];
        _currentImageView = middleImageView;
    }
    return _currentImageView;
}

- (CWImageView *)nextImageView {
    if (!_nextImageView) {
        CWImageView *rightImageView = [[CWImageView alloc] init];
        [self.scrollView addSubview:rightImageView];
        _nextImageView = rightImageView;
    }
    return _nextImageView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return _pageControl;
}

#pragma mark - setter和getter
- (void)setImageGroup:(NSArray<UIImage *> *)imageGroup {
    _imageGroup = imageGroup;
    // 容错处理
    if (!imageGroup) {
        return;
    }
    if (imageGroup.count == 0) {
        return;
    }
    if (imageGroup.count == 1) {
        CWImageView *imageView = [[CWImageView alloc] initWithFrame:self.bounds];
        imageView.image = imageGroup.firstObject;
        [self addSubview:imageView];
        return;
    }
    
    [self setUpAll];
}

- (void)setImageUrls:(NSArray<NSURL *> *)imageUrls {
    _imageUrls = imageUrls;
    
    NSMutableArray<UIImage *> *tempImageArray = [NSMutableArray array];
    
    // 开启一个gcd组
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < imageUrls.count; i++) {
        // 下载图片
        NSURL *url = imageUrls[i];
        // 添加一个任务到gcd组
        dispatch_group_enter(group);
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            // 将下载好的图片赋值给数组
            if (!error && image) {
                [tempImageArray addObject:image];
            } else {
                UIImage *placeholder = (self.placeholderImage == nil) ? [[UIImage alloc] init] : self.placeholderImage;
                [tempImageArray addObject:placeholder];
            }
            dispatch_group_leave(group);
        }];
    }
    // 所有下载任务完毕后才执行
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self.imageGroup = tempImageArray;
    });
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    [self setUpTimer];
}

- (void)setPageControlVisible:(BOOL)pageControlVisible {
    _pageControlVisible = pageControlVisible;
    
    self.pageControl.hidden = !pageControlVisible;
}

- (void)setPageControlPostion:(CWPageControlPostion)pageControlPostion {
    _pageControlPostion = pageControlPostion;
    
    self.pageControl.frame = [self getPageControlFrame];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    self.prevImageView.contentMode = imageContentMode;
    self.currentImageView.contentMode = imageContentMode;
    self.nextImageView.contentMode = imageContentMode;
}

- (void)setAllowDragging:(BOOL)allowDragging {
    _allowDragging = allowDragging;
    self.scrollView.scrollEnabled = allowDragging;
}

- (void)setScrollDirection:(CWScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
}

- (NSUInteger)prevImageIndex {
    return (_currentImageIndex == 0) ? self.imageGroup.count - 1 : _currentImageIndex - 1;
}

- (NSUInteger)nextImageIndex {
    return (_currentImageIndex == self.imageGroup.count - 1) ? 0 : _currentImageIndex + 1;
}

#pragma mark - 事件响应
- (void)imageTapped{
    
    [self.delegate carouselView:self didClickImageOnIndex:self.currentImageIndex];
    
    // 如果设置了代理，则不继续执行block方法
    if (self.delegate != nil) {
        return;
    }
    
    if (self.operations.count == 0) {
        return;
    }
    if (self.operations.count == 1) {
        if (self.operations.firstObject != nil) {
            self.operations.firstObject();
        }
        return;
    }
    
    if (self.operations.count == self.imageGroup.count) {
        void (^operation)() = self.operations[self.currentImageIndex];
        if (operation != nil) {
            operation();
        }
    }
}


#pragma mark - 初始化UI

- (void)setUpAll {
    [self setUpScrollView];
    
    [self setUpImageViews];
    
    [self updateScrollViewContentOffset];
    
    [self setUpPageControl];
    
    [self setUpTimer];
}
// 初始化scrollView
- (void)setUpScrollView {
    CWScrollDirection direction = self.scrollDirection;
    self.scrollView.contentSize = (direction == CWScrollDirectionRight || direction == CWScrollDirectionRight) ? CGSizeMake(3 * CWWidth, 0) : CGSizeMake(0, 3 * CWHeight);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
}

// 添加imageViews
- (void)setUpImageViews {
    
    CGFloat prevX = 0;
    CGFloat prevY = 0;
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat nextX = 0;
    CGFloat nextY = 0;
    
    if (self.scrollDirection == CWScrollDirectionRight || self.scrollDirection == CWScrollDirectionLeft) {
        if (self.scrollDirection == CWScrollDirectionRight) {
            prevX = 0;
            currentX = CWWidth;
            nextX = CWWidth * 2;
        } else {
            prevX = CWWidth * 2;
            currentX = CWWidth;
            nextX = 0;
        }
    } else {
        if (self.scrollDirection == CWScrollDirectionDown) {
            prevY = 0;
            currentY = CWHeight;
            nextY = CWHeight * 2;
        } else {
            prevY = CWHeight * 2;
            currentY = CWHeight;
            nextY = 0;
        }
    }
    
    [self setUpOneImageView:self.prevImageView x:prevX y:prevY Image:self.imageGroup.lastObject];
    [self setUpOneImageView:self.currentImageView x:currentX y:currentY Image:self.imageGroup[0]];
    [self setUpOneImageView:self.nextImageView x:nextX y:nextY Image:self.imageGroup[1]];
    
    __weak __typeof(self) weakSelf = self;
    self.currentImageView.operation = ^{
        [weakSelf imageTapped];
    };
}

// 初始化pageControl
- (void)setUpPageControl {
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = self.imageGroup.count;
    self.pageControl.currentPage = 0;
    
    self.pageControl.frame = [self getPageControlFrame];
    self.pageControl.hidden = !self.pageControlVisible;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
}

// 初始化定时器
- (void)setUpTimer {
    // 先清空，再设置
    [self.timer invalidate];
    self.timer = nil;
    
    // 特殊值,取消轮播
    if (self.interval == -1) {
        return;
    }
    
    NSTimeInterval interval = (self.interval == 0) ? 2.0 : self.interval;
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(moveScrollView) userInfo:nil repeats:YES];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

// 设置一个ImageView
- (void)setUpOneImageView:(CWImageView *)imageView x:(CGFloat)x y:(CGFloat)y Image:(UIImage *)image {
    imageView.frame = CGRectMake(x, y, CWWidth, CWHeight);
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
}

#pragma mark - 更新UI

// 更新视图
- (void)updateCarousel:(CWScrollOption)option {
    [self updateScrollViewContentOffset];
    [self updateCurrentIndex:option];
    [self updateImageViews];
    [self updatePageControlCurrentPage];
}

// 将scrollView的contentOffset恢复到初始位置
- (void)updateScrollViewContentOffset {
    CGPoint startPoint = (self.scrollDirection == CWScrollDirectionRight || self.scrollDirection == CWScrollDirectionLeft) ? CGPointMake(CWWidth, 0) : CGPointMake(0, CWHeight);
    self.scrollView.contentOffset = startPoint;
}

// 更新currentIndex
- (void)updateCurrentIndex:(CWScrollOption)option {
    if (option == CWPrev) {
        _currentImageIndex = (_currentImageIndex == 0) ? self.imageGroup.count - 1 : _currentImageIndex - 1;
    } else if (option == CWNext) {
        _currentImageIndex = (_currentImageIndex == self.imageGroup.count - 1) ? 0 : _currentImageIndex + 1;
    }
}

// 更新所有imageView
- (void)updateImageViews {
    self.prevImageView.image = self.imageGroup[self.prevImageIndex];
    self.currentImageView.image = self.imageGroup[_currentImageIndex];
    self.nextImageView.image = self.imageGroup[self.nextImageIndex];
}

// 更新page当前圆点
- (void)updatePageControlCurrentPage {
    self.pageControl.currentPage = self.currentImageIndex;
}


// 定期滚动
- (void)moveScrollView {
    CGFloat pointX = 0;
    CGFloat pointY = 0;

    if (self.scrollDirection == CWScrollDirectionRight || self.scrollDirection == CWScrollDirectionLeft) {
        if (self.scrollDirection == CWScrollDirectionRight) {
            pointX = 2 * CWWidth;
        }
    } else {
        if (self.scrollDirection == CWScrollDirectionDown) {
            pointY = 2 * CWHeight;
        }
    }
    
    [UIView animateWithDuration:self.scrollAnimationDuration animations:^{
        self.scrollView.contentOffset = CGPointMake(pointX, pointY);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

#pragma mark - 工具方法
// 计算PageControl的Frame
- (CGRect)getPageControlFrame {
    CGFloat pageControlHeight = 20.0;
    CGFloat pageControlWidth = self.imageGroup.count * 20;
    CGFloat pageControlX;
    CGFloat pageControlY;
    switch (self.pageControlPostion) {
        case CWPageControlPostionBottomMiddel:
        {
            pageControlX = (CWWidth - pageControlWidth) *0.5;
            pageControlY = CWHeight - pageControlHeight;
        };
            break;
        case CWPageControlPostionBottomLeft:
        {
            pageControlX = 0;
            pageControlY = CWHeight - pageControlHeight;
        };
            break;
        case CWPageControlPostionBottomRight:
        {
            pageControlX = (CWWidth - pageControlWidth);
            pageControlY = CWHeight - pageControlHeight;
        };
            break;
        case CWPageControlPostionTopMiddel:
        {
            pageControlX = (CWWidth - pageControlWidth) *0.5;
            pageControlY = 0;
        };
            break;
        case CWPageControlPostionTopLeft:
        {
            pageControlX = 0;
            pageControlY = 0;
        };
            break;
        case CWPageControlPostionTopRight:
        {
            pageControlX = (CWWidth - pageControlWidth);
            pageControlY = 0;
        };
            break;
    }
    return CGRectMake(pageControlX, pageControlY, pageControlWidth, pageControlHeight);
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.scrollDirection == CWScrollDirectionRight || self.scrollDirection == CWScrollDirectionLeft) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (self.scrollDirection == CWScrollDirectionRight) {
            if (offsetX == 0) {
                [self updateCarousel:CWPrev];
            } else if (offsetX == CWWidth * 2) {
                [self updateCarousel:CWNext];
            } else {
                return;
            }
        } else {
            if (offsetX == 0) {
                [self updateCarousel:CWNext];
            } else if (offsetX == CWWidth * 2) {
                [self updateCarousel:CWPrev];
            } else {
                return;
            }
        }
    } else {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (self.scrollDirection == CWScrollDirectionDown) {
            if (offsetY == 0) {
                [self updateCarousel:CWPrev];
            } else if (offsetY == CWWidth * 2) {
                [self updateCarousel:CWNext];
            } else {
                return;
            }
        } else {
            if (offsetY == 0) {
                [self updateCarousel:CWNext];
            } else if (offsetY == CWWidth * 2) {
                [self updateCarousel:CWPrev];
            } else {
                return;
            }
        }
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setUpTimer];
}



@end
