//
//  ONEHomeSmallNoteCell.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeViewModel;

@interface ONEHomeHeadContentView : UIView

@property (strong, nonatomic) ONEHomeViewModel *viewModel;

@property (assign, nonatomic) CGFloat headContentViewHeight;

+ (instancetype)headContentView;

- (void)hideSeperatorView;

@end
