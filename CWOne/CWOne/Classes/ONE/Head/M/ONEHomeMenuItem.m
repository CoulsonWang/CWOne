//
//  ONEHomeMenuItem.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeMenuItem.h"
#import "ONECatalogueItem.h"

@implementation ONEHomeMenuItem

+ (instancetype)menuItemWithDict:(NSDictionary *)dict {
    ONEHomeMenuItem *item = [[ONEHomeMenuItem alloc] init];
    item.vol = dict[@"vol"];
    
    NSArray *list = dict[@"list"];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSDictionary *dictionary  in list) {
        ONECatalogueItem *catalogueItem = [ONECatalogueItem catalogueItemWithDict:dictionary];
        [tempArr addObject:catalogueItem];
    }
    item.catelogueItems = tempArr;
    
    
    item.titleString = [NSString stringWithFormat:@"一个  VOL.%@",item.vol];
    
    return item;
}

@end
