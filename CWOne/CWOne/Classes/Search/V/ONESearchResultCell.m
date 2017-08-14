//
//  ONESearchResultCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/14.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONESearchResultCell.h"
#import <UIImageView+WebCache.h>
#import "ONESearchResultItem.h"

@interface ONESearchResultCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@end

@implementation ONESearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSearchResultItem:(ONESearchResultItem *)searchResultItem {
    _searchResultItem = searchResultItem;
    
    NSURL *coverURL = [NSURL URLWithString:searchResultItem.cover];
    [self.iconImageView sd_setImageWithURL:coverURL];
    
    self.resultTitleLabel.text = searchResultItem.title;
    
    self.volumeLabel.text = searchResultItem.subtitle;
}

@end
