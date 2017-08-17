//
//  ONEAllEveryOneAskEveryOneView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONESpecialItem;
@class ONEAllEveryOneAskEveryOneView;

@protocol ONEAllEveryOneAskEveryOneViewDelegate <NSObject>

- (void)everyOneAskEveryOneView:(ONEAllEveryOneAskEveryOneView *)everyOneAskEveryOneView didClickTopicWithSpecialItem:(ONESpecialItem *)specialItem;

@end

@interface ONEAllEveryOneAskEveryOneView : UIView

@property (strong, nonatomic) NSArray<ONESpecialItem *> *specialList;

@property (weak, nonatomic) id<ONEAllEveryOneAskEveryOneViewDelegate> delegate;

@end
