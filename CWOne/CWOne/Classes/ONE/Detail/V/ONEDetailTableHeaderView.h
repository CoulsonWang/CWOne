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

@protocol ONEDetailTableHeaderViewDelegate <NSObject>

- (void)detailTableHeaderView:(ONEDetailTableHeaderView *)detailTableHeaderView WebViewDidFinishLoadWithHeight:(CGFloat)webViewHeight;

@end

@interface ONEDetailTableHeaderView : UIView

@property (weak, nonatomic) id<ONEDetailTableHeaderViewDelegate> delegate;

+ (instancetype)detailTableHeaderViewWithType:(ONEHomeItemType)type;

- (void)webViewLoadHtmlDataWithHtmlString:(NSString *)htmlString;

@end
