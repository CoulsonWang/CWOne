//
//  ONECategoryChooserViewCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/16.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONECategoryChooserViewCell.h"

@interface ONECategoryChooserViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@end

@implementation ONECategoryChooserViewCell

- (void)setCategoryName:(NSString *)categoryName {
    _categoryName = categoryName;
    self.categoryNameLabel.text = categoryName;
}

@end
