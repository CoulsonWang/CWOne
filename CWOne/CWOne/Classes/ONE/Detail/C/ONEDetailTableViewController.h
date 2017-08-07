//
//  ONEDetailTableViewController.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/5.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEDetailTableViewController;

@protocol ONEDetailTableViewControllerDelegate <NSObject>

- (void)detailTableVC:(ONEDetailTableViewController *)detailTableVC changeTitle:(NSString *)title;

@end

@interface ONEDetailTableViewController : UITableViewController

@property (weak, nonatomic) id<ONEDetailTableViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *itemId;

@end
