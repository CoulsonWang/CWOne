//
//  ONEHomeCatalogueView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeMenuItem;


@interface ONEHomeCatalogueView : UIView

@property (strong, nonatomic) ONEHomeMenuItem *menuItem;

@property (assign, nonatomic) CGFloat catalogueHeight;

@property (copy, nonatomic) void (^updateFrame)(BOOL reloadAfterAnimate);


@end
