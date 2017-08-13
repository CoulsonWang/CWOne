//
//  ONEAuthorizationTool.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEAuthorizationTool.h"

@implementation ONEAuthorizationTool

+ (void)requestPhotoLibraryAuthorizationWithCompletion:(void (^)(PHAuthorizationStatus))completion {
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (completion) {
                completion(status);
            }
        }];
    } else {
        if (completion) {
            completion(photoAuthStatus);
        }
    }
}

+ (void)requestCameraAuthorizationWithCompletion:(void (^)(BOOL))completion {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (completion) {
                completion(granted);
            }
        }];
    } else if(authStatus == AVAuthorizationStatusAuthorized) {
        if (completion) {
            completion(YES);
        }
    } else {
        if (completion) {
            completion(NO);
        }
    }
}

@end
