//
//  ONEDetailRelatedCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/8.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDetailRelatedCell.h"
#import "NSString+CWTranslate.h"
#import "ONERelatedItem.h"
#import "ONEUserItem.h"

@interface ONEDetailRelatedCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;

@end

@implementation ONEDetailRelatedCell

- (void)setRelatedItem:(ONERelatedItem *)relatedItem {
    _relatedItem = relatedItem;
    
    self.typeLabel.text = [NSString getCategoryStringWithCategoryInteger:relatedItem.category];
    self.contentLabel.text = relatedItem.title;
    self.authorLabel.text = [NSString stringWithFormat:@"文 / %@",relatedItem.author.user_name];
}

@end
