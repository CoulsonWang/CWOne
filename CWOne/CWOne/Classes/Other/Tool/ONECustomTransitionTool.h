//
//  ONECustomTransitionTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/10.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ONECoverImageOrientationHorizontal,
    ONECoverImageOrientationVertical,
} ONECoverImageOrientation;

@interface ONECustomTransitionTool : NSObject <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIImage *presentImage;

@property (assign, nonatomic) ONECoverImageOrientation orientation;

@property (assign, nonatomic) CGRect originFrame;

@property (strong, nonatomic) NSString *subTitleString;

@property (strong, nonatomic) NSString *volumeString;

+ (instancetype)sharedInstance;

@end
