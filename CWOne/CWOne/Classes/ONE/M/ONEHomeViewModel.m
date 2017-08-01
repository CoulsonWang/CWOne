//
//  ONEHomeViewModel.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"
#import "ONEUserItem.h"

@implementation ONEHomeViewModel

+ (instancetype)viewModelWithItem:(ONEHomeItem *)homeItem {
    ONEHomeViewModel *viewModel = [[ONEHomeViewModel alloc] init];
    viewModel.homeItem = homeItem;
    
    return viewModel;
}

- (void)setHomeItem:(ONEHomeItem *)homeItem {
    _homeItem = homeItem;
    
    // 处理类型标题
    NSString *styleStr;
    if (homeItem.tag_title != nil) {
        styleStr = homeItem.tag_title;
    } else {
        styleStr = [self getCategoryTitleWithType:homeItem.type];
    }
    self.categoryTitle = [NSString stringWithFormat:@"- %@ -",styleStr];
    
    // 处理作者名
    NSString *authorStr;
    if (homeItem.type == ONEHomeItemTypeQuestion) {
        authorStr = homeItem.answererItem.user_name;
    } else {
        authorStr = [NSString stringWithFormat:@"文/ %@",homeItem.authorItem.user_name];
    }
    self.authorString = authorStr;
}


#pragma mark - 工具方法
- (NSString *)getCategoryTitleWithType:(ONEHomeItemType)type {
    switch (type) {
        case ONEHomeItemTypeSmallNote:
            return @"小记";
        case ONEHomeItemTypeEssay:
            return @"阅读";
        case ONEHomeItemTypeSerial:
            return @"连载";
        case ONEHomeItemTypeQuestion:
            return @"问答";
        case ONEHomeItemTypeMusic:
            return @"音乐";
        case ONEHomeItemTypeMovie:
            return @"影视";
        case ONEHomeItemTypeRadio:
            return @"电台";
            
        default:
            return nil;
    }

}

@end
