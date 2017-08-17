//
//  ONEDetailTableHeaderView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/8.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONEHomeItem.h"

@class ONEDetailTableHeaderView;
@class ONEEssayItem;

@protocol ONEDetailTableHeaderViewDelegate <NSObject>

- (void)detailTableHeaderView:(ONEDetailTableHeaderView *)detailTableHeaderView WebViewDidFinishLoadWithHeight:(CGFloat)webViewHeight;

- (void)detailTableHeaderViewDidClickAuthorButton:(ONEDetailTableHeaderView *)detailTableHeaderView;
@end

@interface ONEDetailTableHeaderView : UIView

@property (strong, nonatomic) ONEEssayItem *essayItem;

@property (weak, nonatomic) id<ONEDetailTableHeaderViewDelegate> delegate;

+ (instancetype)detailTableHeaderViewWithType:(ONEHomeItemType)type;

- (void)webViewLoadHtmlDataWithHtmlString:(NSString *)htmlString;


@end
