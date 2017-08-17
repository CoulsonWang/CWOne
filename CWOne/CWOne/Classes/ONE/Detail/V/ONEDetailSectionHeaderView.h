//
//  ONEDetailSectionHeaderView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/8.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEDetailSectionHeaderView : UIView

+ (instancetype)sectionHeaderViewWithTitleString:(NSString *)titleString;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) UIColor *fontColor;

@end
