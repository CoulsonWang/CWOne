//
//  ONESearchTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/14.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONESearchTool : NSObject

+ (instancetype)sharedInstance;

- (void)presentSearchViewController;

- (void)presentSearchResultViewControllerWithSearchText:(NSString *)searchText;

@end
