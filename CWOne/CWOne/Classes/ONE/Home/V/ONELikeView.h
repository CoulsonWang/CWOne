//
//  ONELikeView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeViewModel;

@interface ONELikeView : UIView

+ (instancetype)likeView;

+ (instancetype)likeViewWithLargeImage;

@property (strong, nonatomic) ONEHomeViewModel *viewModel;

/// 点赞数
@property (assign, nonatomic) NSInteger praisenum;

- (void)changeButtonImageToLargeOne;

@end
