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
        styleStr = [self getCategoryTitleWithNumber:homeItem.category.integerValue];
    }
    self.categoryTitle = [NSString stringWithFormat:@"- %@ -",styleStr];
    
    // 处理作者名
    NSString *authorStr;
    if (homeItem.answererItem != nil) {
        authorStr = homeItem.answererItem.user_name;
    } else {
        authorStr = [NSString stringWithFormat:@"文/ %@",homeItem.authorItem.user_name];
    }
    self.authorString = authorStr;
}


#pragma mark - 工具方法
- (NSString *)getCategoryTitleWithNumber:(NSInteger)num {
    switch (num) {
        case 0:
            return @"小记";
        case 1:
            return @"阅读";
        case 2:
            return @"连载";
        case 3:
            return @"问答";
        case 4:
            return @"音乐";
        case 5:
            return @"影视";
        case 8:
            return @"电台";
            
        default:
            return nil;
    }

}

@end
