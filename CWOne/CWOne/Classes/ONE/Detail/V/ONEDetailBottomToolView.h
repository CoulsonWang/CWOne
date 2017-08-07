//
//  ONEDetailBottomToolView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/6.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ONEDetailBottomToolView : UIView

+ (instancetype)detailBottomToolView;

/// 点赞数
@property (assign, nonatomic) NSInteger praisenum;

/// 评论数
@property (assign, nonatomic) NSInteger commentnum;

@end
