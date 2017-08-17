//
//  ONEAuthorHeaderInfoView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/17.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEUserItem;

@interface ONEAuthorHeaderInfoView : UIView

@property (strong, nonatomic) ONEUserItem *author;

@property (assign, nonatomic) CGFloat headerViewHeight;

+ (instancetype)authorHeaderInfoView;

@end
