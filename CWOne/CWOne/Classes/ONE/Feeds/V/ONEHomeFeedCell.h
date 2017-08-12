//
//  ONEHomeFeedCell.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEFeedItem;

@interface ONEHomeFeedCell : UICollectionViewCell

@property (strong, nonatomic) ONEFeedItem *feedItem;

@property (assign, nonatomic) BOOL isToday;

@end
