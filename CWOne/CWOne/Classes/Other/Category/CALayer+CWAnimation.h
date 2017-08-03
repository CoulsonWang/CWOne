//
//  CALayer+CWAnimation.h
//  暂停和恢复动画
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (CWAnimation)

- (void)pauseAnimate;

- (void)resumeAnimate;

@end
