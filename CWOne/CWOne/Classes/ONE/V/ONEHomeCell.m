//
//  ONEHomeCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/1.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCell.h"
#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"

@interface ONEHomeCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image_View;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation ONEHomeCell

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.categoryLabel.text = viewModel.categoryTitle;
    self.titleLabel.text = viewModel.homeItem.title;
    self.authorLabel.text = viewModel.authorString;
}




- (IBAction)likeButtonClick:(UIButton *)sender {
}
- (IBAction)shareButtonClick:(UIButton *)sender {
}

@end
