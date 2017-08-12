//
//  ONEDiaryPhotoPickerView.m
//  CWOne
//
//  Created by Coulson_Wang on 2017/8/12.
//  Copyright © 2017年 Coulson_Wang. All rights reserved.
//

#import "ONEDiaryPhotoPickerView.h"
#import "ONENavigationBarTool.h"
#import "ONEPhotoPickerViewButton.h"
#import <Photos/Photos.h>
#import <SVProgressHUD.h>

#define kAnimationDuration 0.3
#define kButtonHorizontalDistance 100.0
#define kBackgroundAlpha 0.96

#define kButtonWidth 60.0
#define kButtonHeigth 100.0

@interface ONEDiaryPhotoPickerView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) ONEPhotoPickerViewButton *cameraButton;
@property (weak, nonatomic) ONEPhotoPickerViewButton *photoLibraryButton;

@property (weak, nonatomic) UIImagePickerController *pickerVC;
@end

@implementation ONEDiaryPhotoPickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:kBackgroundAlpha];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePhotoPickerView)]];
    
    ONEPhotoPickerViewButton *cameraButton = [ONEPhotoPickerViewButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setImage:[UIImage imageNamed:@"cameraNormalImage"] forState:UIControlStateNormal];
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor colorWithWhite:130/255.0 alpha:1.0] forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cameraButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.width = kButtonWidth;
    cameraButton.height = kButtonHeigth;
    cameraButton.centerX = CWScreenW * 0.5;
    cameraButton.centerY = CWScreenH * 0.5;
    [self addSubview:cameraButton];
    self.cameraButton = cameraButton;
    
    ONEPhotoPickerViewButton *photoLibraryButton = [ONEPhotoPickerViewButton buttonWithType:UIButtonTypeCustom];
    [photoLibraryButton setImage:[UIImage imageNamed:@"libraryNormalImage"] forState:UIControlStateNormal];
    [photoLibraryButton setTitle:@"相册" forState:UIControlStateNormal];
    [photoLibraryButton setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    photoLibraryButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [photoLibraryButton addTarget:self action:@selector(openPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    photoLibraryButton.width = kButtonWidth;
    photoLibraryButton.height = kButtonHeigth;
    photoLibraryButton.centerX = CWScreenW * 0.5;
    photoLibraryButton.centerY = CWScreenH * 0.5;
    [self addSubview:photoLibraryButton];
    self.photoLibraryButton = photoLibraryButton;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(CWScreenW - 40, 20, 20, 20)];
    [closeButton setImage:[UIImage imageNamed:@"close_gray"] forState:UIControlStateNormal];
    [closeButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePhotoPickerView)]];
    [self addSubview:closeButton];
}

- (void)showPhotoPickerView {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.cameraButton.x -= kButtonHorizontalDistance;
        self.photoLibraryButton.x += kButtonHorizontalDistance;
        [[ONENavigationBarTool sharedInstance] changeStatusBarAlpha: 1 - kBackgroundAlpha];
    }];
}

#pragma mark - 私有方法
- (void)hidePhotoPickerView {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.cameraButton.centerX = CWScreenW * 0.5;
        self.photoLibraryButton.centerX = CWScreenW * 0.5;
        self.alpha = 0;
        [[ONENavigationBarTool sharedInstance] changeStatusBarAlpha: 1];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)openCamera {
    
}
- (void)openPhotoLibrary {
    // 权限处理
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthStatus == PHAuthorizationStatusNotDetermined) {
        // 请求授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 打开图片选择器
                [self presentImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            } else {
                // 提示无法选取图片
                [self showAuthorizationErrorWithMessage:@"无法访问您的相册"];
            }
        }];
    }else if(photoAuthStatus == PHAuthorizationStatusAuthorized) {
        [self presentImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    } else {
        [self showAuthorizationErrorWithMessage:@"无法访问您的相册"];
    }
}
#pragma mark - 工具方法
- (void)showAuthorizationErrorWithMessage:(NSString *)errorMessage {
    [SVProgressHUD showErrorWithStatus:errorMessage];
    [SVProgressHUD dismissWithDelay:1.0];
}

- (void)presentImagePickerControllerWithType:(UIImagePickerControllerSourceType)type {
    [self hidePhotoPickerView];
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerVC.allowsEditing = NO;
        pickerVC.delegate = self;
        pickerVC.navigationBar.tintColor = [UIColor grayColor];
        [self presentVC:pickerVC];
    }
}

- (void)cancelPick {
    
}

- (void)presentVC:(UIImagePickerController *)pickerVC {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    [rootVC presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.delegate photoPickerView:self didPickImage:image];
    }];
}
@end
