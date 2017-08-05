//
//  ONECatalogueItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONECatalogueItem.h"

@implementation ONECatalogueItem

+ (instancetype)catalogueItemWithDict:(NSDictionary *)dict {
    ONECatalogueItem *item = [[ONECatalogueItem alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    
    if(item.tag) {
        item.categoryString = item.tag[@"title"];
    } else {
        switch (item.content_type.integerValue) {
            case 0:
                item.categoryString = @"小记";
                break;
            case 1:
                item.categoryString = @"阅读";
                break;
            case 2:
                item.categoryString = @"连载";
                break;
            case 3:
                item.categoryString = @"问答";
                break;
            case 4:
                item.categoryString = @"音乐";
                break;
            case 5:
                item.categoryString = @"影视";
                break;
            case 8:
                item.categoryString = @"电台";
                break;
            default:
                item.categoryString = nil;
                break;
        }
    }
    
    
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // do nothing
}

@end
