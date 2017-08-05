//
//  ONEHomeBaseCell.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/2.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//  自定义cell的基类，用于继承


#import <UIKit/UIKit.h>

@class ONEHomeViewModel;

@interface  ONEHomeBaseCell: UITableViewCell

@property (strong, nonatomic) ONEHomeViewModel *viewModel;

@end
