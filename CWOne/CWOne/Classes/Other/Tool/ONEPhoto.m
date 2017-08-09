//
//  ONEPhoto.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/9.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEPhoto.h"

@implementation ONEPhoto

+ (ONEPhoto *)createPhotoObjectWihtImage:(UIImage *)image {
    ONEPhoto *photo = [[ONEPhoto alloc] init];
    photo.image = image;
    photo.imageData = nil;
    photo.placeholderImage = nil;
    photo.attributedCaptionTitle = nil;
    photo.attributedCaptionCredit = nil;
    photo.attributedCaptionSummary = nil;
    
    return photo;
}

@end
