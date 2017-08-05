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

@property (strong, nonatomic) ONEHomeViewModel *viewModel;

@end
