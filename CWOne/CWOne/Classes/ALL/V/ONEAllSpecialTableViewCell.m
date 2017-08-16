//
//  ONEAllSpecialTableViewCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/15.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllSpecialTableViewCell.h"
#import "ONESpecialItem.h"
#import <UIImageView+WebCache.h>
#import "UILabel+CWLineSpacing.h"
#import "UIImageView+ONEAddTag.h"

@interface ONEAllSpecialTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ONEAllSpecialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.infoLabel.font = [UIFont systemFontOfSize:16.0 weight:-0.1];
    
    
    [self.coverImageView addTagViewWithTagText:@"专题"];
}


- (void)setSpecialItem:(ONESpecialItem *)specialItem {
    NSURL *coverURL = [NSURL URLWithString:specialItem.cover];
    [self.coverImageView sd_setImageWithURL:coverURL];
    
    [self.infoLabel setText:specialItem.title lineSpacing:13.5];
    self.infoLabel.text = specialItem.title;
}

@end
