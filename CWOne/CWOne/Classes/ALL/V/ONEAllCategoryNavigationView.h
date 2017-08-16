//
//  ONEAllCategoryNavigationView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEAllCategoryNavigationView;

@protocol ONEAllCategoryNavigationViewDelegate <NSObject>

- (void)categoryNavigationView:(ONEAllCategoryNavigationView *)categoryNavigationView didClickButtonWithCategoryIndex:(NSInteger)categoryIndex;

@end

@interface ONEAllCategoryNavigationView : UIView

@property (weak, nonatomic) id<ONEAllCategoryNavigationViewDelegate> delegate;

+ (instancetype)categoryNavigationView;

@end
