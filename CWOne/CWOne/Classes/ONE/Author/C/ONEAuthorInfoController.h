//
//  ONEAuthorInfoController.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEUserItem;

@interface ONEAuthorInfoController : UITableViewController

@property (strong, nonatomic) ONEUserItem *author;

@property (assign, nonatomic) NSInteger author_id;

@end
