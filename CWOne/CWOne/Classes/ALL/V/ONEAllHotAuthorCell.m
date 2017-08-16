//
//  ONEAllHotAuthorCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllHotAuthorCell.h"
#import "ONEUserItem.h"
#import <UIImageView+WebCache.h>

@interface ONEAllHotAuthorCell ()
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorDescripLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end

@implementation ONEAllHotAuthorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.followButton.layer.borderWidth = 1;
    self.followButton.layer.borderColor = [UIColor colorWithWhite:170/255.0 alpha:1.0].CGColor;
    self.followButton.layer.cornerRadius = 2;
    
    self.authorImageView.layer.cornerRadius = self.authorImageView.width * 0.5;
    self.authorImageView.layer.masksToBounds = YES;
    
    self.followButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:-0.2];
}

- (void)setAuthorItem:(ONEUserItem *)authorItem {
    _authorItem = authorItem;
    
    NSURL *authorIconURL = [NSURL URLWithString:authorItem.web_url];
    [self.authorImageView sd_setImageWithURL:authorIconURL placeholderImage:[UIImage imageNamed:@"userDefault"]];
    
    self.authorNameLabel.text = authorItem.user_name;
    
    self.authorDescripLabel.text = authorItem.desc;
}

- (IBAction)followButtonClick:(UIButton *)sender {
}

@end
