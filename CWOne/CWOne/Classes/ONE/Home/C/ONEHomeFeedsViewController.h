//
//  ONEHomeFeedsViewController.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/10.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEHomeFeedsViewController;

@protocol ONEHomeFeedsViewControllerDelegate <NSObject>

- (void)feedsViewController:(ONEHomeFeedsViewController *)feedsViewController didSelectedCollectionViewWithDateString:(NSString *)dateString;

@end

@interface ONEHomeFeedsViewController : UIViewController

@property (strong, nonatomic) NSString *dateString;

@property (weak, nonatomic) id<ONEHomeFeedsViewControllerDelegate> delegate;

@end
