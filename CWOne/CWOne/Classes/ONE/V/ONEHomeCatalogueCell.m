//
//  ONEHomeCatalogueCell.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCatalogueCell.h"
#import "ONECatalogueItem.h"

@interface ONEHomeCatalogueCell ()
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation ONEHomeCatalogueCell

- (void)setItem:(ONECatalogueItem *)item {
    _item = item;
    self.categoryLabel.text = item.categoryString;
    self.summaryLabel.text = item.title;
}

@end
