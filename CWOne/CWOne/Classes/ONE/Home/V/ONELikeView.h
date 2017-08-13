//
//  ONELikeView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeViewModel;
@class ONEEssayItem;

@interface ONELikeView : UIView

+ (instancetype)likeView;

+ (instancetype)likeViewWithLargeImage;

@property (strong, nonatomic) ONEHomeViewModel *viewModel;

@property (strong, nonatomic) ONEEssayItem *essayItem;

@property (assign, nonatomic) BOOL isSummary;

- (void)changeButtonImageToLargeOne;

@end
