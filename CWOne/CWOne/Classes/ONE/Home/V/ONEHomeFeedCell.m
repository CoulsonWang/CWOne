//
//  ONEHomeFeedCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeFeedCell.h"
#import <UIImageView+WebCache.h>
#import "ONEFeedItem.h"
#import "ONEDateTool.h"

@interface ONEHomeFeedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *borderView;

@end

@implementation ONEHomeFeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.borderView.layer.borderColor= [UIColor colorWithWhite:240/255.0 alpha:1.0].CGColor;
    self.borderView.layer.borderWidth = 1;
}

- (void)setFeedItem:(ONEFeedItem *)feedItem {
    _feedItem = feedItem;
    
    NSURL *imageURL = [NSURL URLWithString:feedItem.cover];
    [self.coverImageView sd_setImageWithURL:imageURL];
    
    self.dateLabel.text = [[ONEDateTool sharedInstance] getFeedsDateStringWithOriginalDateString:feedItem.date];
}

@end
