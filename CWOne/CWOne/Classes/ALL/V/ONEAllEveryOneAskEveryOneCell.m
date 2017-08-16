//
//  ONEAllEveryOneAskEveryOneCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAllEveryOneAskEveryOneCell.h"
#import <UIImageView+WebCache.h>
#import "ONESpecialItem.h"
#import "UIImageView+ONEAddTag.h"

@interface ONEAllEveryOneAskEveryOneCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleInfoLabel;

@end

@implementation ONEAllEveryOneAskEveryOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    [self.coverImageView addTagViewWithTagText:@"专题"];
}

- (void)setSpecialItem:(ONESpecialItem *)specialItem {
    
    NSURL *coverImageUrl = [NSURL URLWithString:specialItem.cover];
    [self.coverImageView sd_setImageWithURL:coverImageUrl];
    
    self.titleInfoLabel.text = specialItem.title;
}

@end
