//
//  ONEUserHeaderView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEUserInfoItem;

@interface ONEUserHeaderView : UIView

@property (strong, nonatomic) ONEUserInfoItem *userInfoItem;

+ (instancetype)userHeaderView;

- (void)updateBackgroundViewHeightWithOffsetY:(CGFloat)offsetY;

@end
