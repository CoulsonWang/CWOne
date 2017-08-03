//
//  ONEHomeCatalogueView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/3.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEHomeCatalogueView.h"
#import "ONEHomeMenuItem.h"
#import "ONECatalogueItem.h"

@interface ONEHomeCatalogueView ()

@property (weak, nonatomic) UIButton *titleButton;

@property (weak, nonatomic) UIImageView *arrowView;

@property (weak, nonatomic) UITableView *listView;

@property (strong, nonatomic) NSArray<ONECatalogueItem *> *cataLogueItems;

@end

@implementation ONEHomeCatalogueView

- (void)setMenuItem:(ONEHomeMenuItem *)menuItem {
    _menuItem = menuItem;
    
    self.cataLogueItems = menuItem.catelogueItems;
    
    self.catalogueHeight = 50;
}

@end
