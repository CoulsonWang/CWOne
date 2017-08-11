//
//  ONEHomeFeedHeaderView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/11.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeFeedHeaderView.h"
#import "NSString+ONEComponents.h"

@interface ONEHomeFeedHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ONEHomeFeedHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    
    NSDateComponents *components = [dateString getComponents];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%ld月",components.month];
}

@end
