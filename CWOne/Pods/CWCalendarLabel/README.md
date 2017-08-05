# CWCalendarLabel

![Pod Version](https://img.shields.io/cocoapods/v/CWCalendarLabel.svg?style=flat)
![Pod Platform](https://img.shields.io/cocoapods/p/CWCalendarLabel.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/CWCalendarLabel.svg?style=flat)



## 功能简介

CWCalendarLabel是一个轻量级的Label控件，可以快速实现日历效果的文本动画。



## 安装

##### 1.CocoaPods

如果你的项目使用CocoaPods管理三方库，那么仅需在你的Podfile文件中，加上` pod 'CWCalendarLabel'`即可。

##### 2.手动导入

下载项目文件夹后，将`CWCalendarLabel`文件夹拖拽到你的项目中，即可集成。



##### 导入头文件

在需要用到CWCarouselView的文件中，导入`#import "CWCalendarLabel"`即可



## 演示Demo

本工程文件中附带了一个演示Demo：`CWCalendarLabelDemo`，在Xcode中直接运行即可查看。



## 使用方法

#### 使用CWCalendarLabel类代替UILabel

导入头文件后，只需创建一个CWCalendarLabel对象，将其替换你的UILabel，添加到需要显示的View上，即可创建该控件：

```objective-c
#import "CWCalendarLabel.h"
	
	CWCalendarLabel *calendarLabel = [[CWCalendarLabel alloc] init];
    calendarLabel.text = @"测试";
	[self.view addSubview:calendarLabel];
```



#### 实现滚动切换文本

CWCalendarLabel中有且仅有一个核心方法，只需调用该方法即可：

```objective-c
/**
 核心方法，播放滚动动画

 @param nextText 新的文本
 @param direction 滚动方向
 */
- (void)showNextText:(NSString *)nextText withDirection:(CWCalendarLabelScrollDirection)direction;
```

其中滚动方向是一个枚举，支持向上滚动和向下滚动两个方向：

```objective-c
typedef enum : NSUInteger {
    CWCalendarLabelScrollToTop,
    CWCalendarLabelScrollToBottom,
} CWCalendarLabelScrollDirection;
```



方法调用示例:

```objective-c
static int i = 99;
- (IBAction)scrollToTop:(UIButton *)sender {
    i += 1;
    NSString *str = [NSString stringWithFormat:@"%d",i];
    [self.label showNextText:str withDirection:CWCalendarLabelScrollToTop];
}
```

每次点击按钮，都会播放一次滚动动画，显示新的文本。



#### 自定义属性

由于继承自UILabel，只要UILabel中具有的属性，CWCalendarLabel均支持。在设置Label属性的同时，也会为动画Label设置相同的属性。

可自定义的属性有：

###### ·自定义动画时长

```objective-c
// 动画播放时长，默认为0.5
@property (assign, nonatomic) NSTimeInterval animateDuration;

// 示例
calendarLabel.animateDuration = 1.0;
```

###### ·自定义间距：

```objective-c
// 动画label与原label之间的额外垂直间距，默认为0(紧贴)
@property (assign, nonatomic) CGFloat distance;

// 示例
calendarLabel.distance = 10.0;
```

如果对于自定义属性有其他好的想法或建议，欢迎issue或pull request!



## 实现思路

- 调用核心方法时，添加两个临时的lable，用于播放动画，并暂时隐藏原有lable