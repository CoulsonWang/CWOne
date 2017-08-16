//
//  CWImageView.h
//  CWCarouselView
//
//  Created by Coulson_Wang on 2017/7/22.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWImageView : UIImageView

@property (copy, nonatomic) void (^operation)();


@end
