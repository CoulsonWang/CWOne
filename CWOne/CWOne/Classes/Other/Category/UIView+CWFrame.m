//
//  UIView+CWFrame.m
//  CWFrame
//
//  Created by Coulson_Wang on 2017/7/28.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "UIView+CWFrame.h"

@implementation UIView (CWFrame)

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
    self.frame = newFrame;
}

- (CGFloat)y {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    self.frame = newFrame;
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect bounds = self.bounds;
    CGRect newBounds = CGRectMake(bounds.origin.x, bounds.origin.y, width, bounds.size.height);
    self.bounds = newBounds;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect bounds = self.bounds;
    CGRect newBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, height);
    self.bounds = newBounds;
}

@end
