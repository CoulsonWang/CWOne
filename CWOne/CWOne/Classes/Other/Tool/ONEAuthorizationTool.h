//
//  ONEAuthorizationTool.h
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/13.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>

@interface ONEAuthorizationTool : NSObject

/// 请求相册权限，如果已经请求过，直接执行block
+ (void)requestPhotoLibraryAuthorizationWithCompletion:(void(^)(PHAuthorizationStatus status))completion;

/// 请求照相机权限，如果已经请求过，直接执行block
+ (void)requestCameraAuthorizationWithCompletion:(void(^)(BOOL granted))completion;

/// 获取当前定位状态
+ (CLAuthorizationStatus)getCurrentLocationStatus;

@end
