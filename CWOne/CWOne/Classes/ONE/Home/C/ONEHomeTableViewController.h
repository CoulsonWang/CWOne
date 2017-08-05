//
//  ONEHomeController.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeTableViewController;

@protocol ONEHomeTableViewControllerDelegate <NSObject>

- (void)homeTableViewFooterButtonClick:(ONEHomeTableViewController *)homeTableViewController;

@end

@interface ONEHomeTableViewController : UITableViewController

@property (strong, nonatomic) NSString *dateStr;

@property (weak, nonatomic) id<ONEHomeTableViewControllerDelegate> delegate;

- (void)setDateStr:(NSString *)dateStr withCompletion:(void (^)())completion;



@end
