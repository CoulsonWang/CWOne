//
//  ONEHomeAdvertisementCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeAdvertisementCell.h"
#import <UIImageView+WebCache.h>
#import "ONEHomeViewModel.h"
#import "ONEHomeItem.h"

@interface ONEHomeAdvertisementCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation ONEHomeAdvertisementCell

- (void)setViewModel:(ONEHomeViewModel *)viewModel {
    [super setViewModel:viewModel];
    
    NSURL *imageURL = [NSURL URLWithString:viewModel.homeItem.img_url];
    [self.coverImageView sd_setImageWithURL:imageURL];
}


@end
