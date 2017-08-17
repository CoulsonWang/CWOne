//
//  ONEAllHotAuthorView.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEUserItem;

@interface ONEAllHotAuthorView : UIView

@property (strong, nonatomic) NSArray<ONEUserItem *> *hotAuthorList;

+ (instancetype)hotAuthorViewWithClickOperation:(void(^)(ONEUserItem *author))operation;

@end
