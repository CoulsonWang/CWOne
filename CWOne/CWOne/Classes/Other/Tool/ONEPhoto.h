//
//  ONEPhoto.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/9.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NYTPhoto.h>

@interface ONEPhoto : NSObject <NYTPhoto>

@property (nonatomic) UIImage *image;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;


+ (ONEPhoto *)createPhotoObjectWihtImage:(UIImage *)image;


@end
